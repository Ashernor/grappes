class Mood
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :title, type: String

  belongs_to :travel
  belongs_to :city
  belongs_to :airport

  # Image upload with Paperclip & Mongoid
  has_mongoid_attached_file :icon,
    :styles => {
      :original    => ['100x100#',   :jpg],
      :normal   => ['35x35',    :jpg],
    }
  do_not_validate_attachment_file_type :icon

end