require 'action_view'
include ActionView::Helpers::DateHelper

class Travel
  include Mongoid::Document
  include Mongoid::Timestamps

  field :start_city, type: String
  field :end_city, type: String
  field :price, type: Float
  field :places_available, type: Integer
  field :about, type: String
  field :departure, type: DateTime
  field :arrival, type: DateTime
  field :direct_trip, type: Mongoid::Boolean
  field :company, type: String
  field :lowcost, type: Mongoid::Boolean
  field :type, type: String
  field :start_airport, type: String
  field :end_airport, type: String

  # We use several scopes to filter in the model

  # We want to only return the travels between a range of price
  scope :in_budget, lambda { |start_price, end_price|
    where(:price => {'$gte' => start_price.to_f, '$lte' => end_price.to_f})
  }

  # Only return the travel between a date range
  scope :between_dates, lambda { |start_date, end_date|
    all_of(
      {:departure => {'$gte' => Date.strptime(start_date,"%m/%d/%Y").to_datetime }},
      {:arrival => {'$lte' => Date.strptime(end_date,"%m/%d/%Y").to_datetime }}
    )
  }

  scope :with_people, lambda { |number_of_people|
    where(:places_available => {'$gte' => number_of_people.to_i})
  }

  scope :from, lambda { |city|
    any_of({ :start_city => /.*#{city.capitalize}.*/ })
  }

  # The duration of a trip is the time difference between arrival and departure
  def self.duration
    return 0 if departure_time.nil? || arrival_time.nil?

    self.distance_of_time_in_words(departure_time, arrival_time)
  end

  # Import method
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Travel.create! row.to_hash
    end
  end
end
