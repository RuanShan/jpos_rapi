object false
child(@stores => :stores) do
  attributes *store_attributes
  node("site_sms_templates") { |i| i.site_sms_templates }
  node("site_has_factory") { |i| i.site_has_factory }
end
