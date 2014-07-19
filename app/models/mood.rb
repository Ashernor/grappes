class Mood
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :icon, type: String

end