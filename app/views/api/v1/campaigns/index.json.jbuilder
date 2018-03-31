json.paginate_meta do
  paginate_meta_attributes(json, @campaigns)
end
json.campaigns do
  json.array! @campaigns do |campaign|
    json.(campaign, :id, :name, :start_at, :end_at, :created_at)
  end
end
