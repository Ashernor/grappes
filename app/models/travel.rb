require 'action_view'
include ActionView::Helpers::DateHelper
include Geocoder::Model::Mongoid

class Travel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Attributes::Dynamic

  field :start_city, type: String
  field :end_city, type: String
  field :end_country, type: String
  field :price, type: Float
  field :places_available, type: Integer
  field :about, type: String
  field :departure, type: DateTime
  field :arrival, type: DateTime
  field :stopover, type: Integer
  field :company, type: String
  field :lowcost, type: Mongoid::Boolean
  field :type, type: String
  field :start_airport, type: String
  field :start_airport_code, type: String
  field :end_airport_code, type: String
  field :end_airport, type: String
  field :coordinates, :type => Array
  field :title, :type => String
  field :prefered, :type => Mongoid::Boolean
  #Automatic fields
  field :start_time, type: Float
  field :end_time, type: Float
  field :duration, type: Integer

  geocoded_by :end_city               # can also be an IP address

  # MongoDB Associations
  embeds_many :moods
  accepts_nested_attributes_for :moods

  # Image upload with Paperclip & Mongoid
  has_mongoid_attached_file :image,
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg],
      :large    => ['500x500>',   :jpg]
    }
  do_not_validate_attachment_file_type :image

  before_validation :set_duration
  before_validation :set_start_time
  before_validation :set_end_time
  before_validation :set_default_stopover
  after_validation :geocode          # auto-fetch coordinates

  # We use several scopes to filter in the model

  # We want to only return the travels between a range of price
  scope :in_budget, lambda { |start_price, end_price|
    where(:price => {'$gte' => start_price.to_f, '$lte' => end_price.to_f})
  }

  # Only return the travel between a date range
  scope :between_dates, lambda { |start_date, end_date|
    all_of(
      {:departure => {'$gte' => Date.strptime(start_date,"%d/%m/%Y").to_datetime }},
      {:arrival => {'$lte' => Date.strptime(end_date,"%d/%m/%Y").to_datetime }}
    )
  }

  scope :with_people, lambda { |number_of_people|
    where(:places_available => {'$gte' => number_of_people.to_i})
  }

  scope :from, lambda { |city|
    any_of({ :start_city => /.*#{city.capitalize}.*/ })
  }

  scope :prefered, lambda { |test|
    where(:prefered => true)
  }

  scope :within_duration, lambda { |min_duration, max_duration|
    where(:duration => {'$gte' => min_duration.to_i, '$lte' => max_duration.to_i})
  }

  scope :within_start_time, lambda { |start_time_min, start_time_max|
    where(:start_time => {'$gte' => start_time_min.to_f, '$lte' => start_time_max.to_f})
  }

  scope :within_end_time, lambda { |end_time_min, end_time_max|
    where(:end_time => {'$gte' => end_time_min, '$lte' => end_time_max})
  }

  scope :number_of_stopover, lambda { |nb_of_stopover|
    where(:stopover => {:$lte => nb_of_stopover.to_i})
  }

  scope :not_in_countries, lambda { |countries|
    not_in(:end_country => countries)
  }

  scope :not_in_companies, lambda { |companies|
    not_in(:company => companies)
  }

  # Import method
  def self.import(file)
    SmarterCSV.process(file.path) do |array|
      # we're passing a block in, to process each resulting hash / =row (the block takes array of hashes)
      # when chunking is not enabled, there is only one hash in each array
      Travel.create( array.first )
    end
  end

  private

  # The duration of a trip is the time difference between arrival and departure
  def set_duration
    return 0 if departure.nil? || arrival.nil?

    self.duration = ((Time.parse(arrival.to_s) - Time.parse(departure.to_s))/3600).round
  end

  def set_default_stopover
    self.stopover = 0 if self.stopover.nil?
  end

  def set_start_time
    self.start_time = self.departure.strftime("%H.%M").to_f unless self.start_time.nil?
  end

  def set_end_time
    self.end_time = self.arrival.strftime("%H.%M").to_f unless self.end_time.nil?
  end
end
