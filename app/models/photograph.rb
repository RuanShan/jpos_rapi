class Photograph < ApplicationRecord
  has_attached_file :image
  validates_attachment_content_type :image,
    content_type: %w(image/jpeg image/jpg image/png image/gif),
    message: "is not gif, png, jpg, or jpeg."

  belongs_to :game_player
  #https://stackoverflow.com/questions/27234065/how-to-upload-a-base-64-image-to-rails-paperclip
  attr_accessor :base64_image

  before_validation :save_base64_image

  # call this explicitly from the controller or in an after_save callback
  # after setting the base64_image attribute
  def save_base64_image
   if base64_image.present?
       adapter = Paperclip.io_adapters.for(base64_image)
       adapter.original_filename = "wedding.png"
       self.image = adapter
     end
  end
end
