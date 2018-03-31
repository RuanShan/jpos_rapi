Paperclip.interpolates :viewable_id do |attachment, _style|
  attachment.instance.viewable_id
end

class GameRoundAsset < ApplicationRecord
  belongs_to :viewable, polymorphic: true, touch: true
end
