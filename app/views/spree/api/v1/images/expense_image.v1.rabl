object @image
attributes :id, :position, :attachment_file_name
attributes :viewable_type, :viewable_id
['large', 'mini'].each do |k, _v|
  node("#{k}_url") { |i| i.attachment.url(k) }
end

node("original_url") { |i| i.attachment.url(:original) }
