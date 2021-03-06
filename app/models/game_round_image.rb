class GameRoundImage < GameRoundAsset
    validate :no_attachment_errors

    def self.accepted_image_types
      %w(image/jpeg image/jpg image/png image/gif)
    end

    has_attached_file :attachment,
                      styles: { mini: '48x48>' },
                      default_style: :original,
                      url: '/uploads/game_round_images/:id/:style/:basename.:extension',
                      path: ':rails_root/public/uploads/game_round_images/:id/:style/:basename.:extension',
                      convert_options: { all: '-strip -auto-orient -colorspace sRGB' }
    validates_attachment :attachment,
                         presence: true,
                         content_type: { content_type: accepted_image_types }

    # save the w,h of the original image (from which others can be calculated)
    # we need to look at the write-queue for images which have not been saved yet
    before_save :find_dimensions, if: :attachment_updated_at_changed?

    # used by admin products autocomplete
    def mini_url
      attachment.url(:mini, false)
    end

    def find_dimensions
      temporary = attachment.queued_for_write[:original]
      filename = temporary.path unless temporary.nil?
      filename = attachment.path if filename.blank?
      geometry = Paperclip::Geometry.from_file(filename)
      self.attachment_width  = geometry.width
      self.attachment_height = geometry.height
    end

    # if there are errors from the plugin, then add a more meaningful message
    def no_attachment_errors
      unless attachment.errors.empty?
        # uncomment this to get rid of the less-than-useful interim messages
        # errors.clear
        errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
        false
      end
    end
end
