require 'action_view'
include ActionView::Helpers::DateHelper
include Geocoder::Model::Mongoid

class City
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Attributes::Dynamic

  field :name, :type => String
  field :title, :type => String

  field :coordinates, :type => Array

  has_many :moods

  # Image upload with Paperclip & Mongoid
  has_mongoid_attached_file :image,
    :styles => {
      :original => ['1920x1680>', :jpg],
      :small    => ['100x100#',   :jpg],
      :medium   => ['250x250',    :jpg],
      :large    => ['500x500>',   :jpg]
  }
  do_not_validate_attachment_file_type :image

end
