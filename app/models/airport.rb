require 'action_view'
include Geocoder::Model::Mongoid

class Airport
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field    :name                , type: String
  field    :city                , type: String
  field    :country             , type: String
  field    :iata_code           , type: String
  field    :icao                , type: String
  field    :latitude            , type: Float
  field    :longitude           , type: Float
  field    :altitude            , type: Float
  field    :utc_timezone_offset , type: Float
  field    :daily_save_time     , type: String
  field    :timezone            , type: String
  field    :first_class         , type: Boolean, default: false


  geocoded_by :iata_code        # can also be an IP address

  scope :first_class, -> { where(first_class: true).ne(iata_code: '')}
end
