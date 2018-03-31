json.extract! photograph, :id, :name, :desc, :created_at, :updated_at
json.image_url asset_url(photograph.image.url)
