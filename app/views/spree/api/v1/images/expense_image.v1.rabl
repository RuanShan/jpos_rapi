object @image
attributes :id, :position, :attachment_file_name
attributes :viewable_type, :viewable_id
#['large', 'mini'].each do |k, _v|
#  node("#{k}_url") { |i| main_app.url_for(i.url(k)) }
#end
['large', 'mini'].each do |k, _v|
  node("#{k}_url") { |i| i.attachment.service_url( params: { "x-oss-process" => "style/#{k}" }) }
end

#node("original_url") { |i| main_app.url_for(i.attachment)}
node("original_url") { |i| i.attachment.service_url }
