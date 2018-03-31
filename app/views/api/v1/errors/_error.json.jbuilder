json.status @error_serializer.status
json.errors do
  json.array! @error_serializer.errors do |error|
    json.(error, :title, :detail, :source )
  end
end
