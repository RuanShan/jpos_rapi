object @image
attributes :id, :position, :attachment_file_name
attributes :viewable_type, :viewable_id

['large', 'mini'].each do |k, _v|
  node("#{k}_url") { |i| main_app.url_for(i.url(k)) }
end

node("original_url") { |i| main_app.url_for(i.attachment)}
