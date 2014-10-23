require 'action_view'
include ActionView::Helpers::DateHelper

class ServerApikey

  include Mongoid::Document

  field    :key              , type: String
  field    :last_call_date   , type: Time
  field    :day_api_calls    , type: Integer


end
