json.extract! game_setting, :id, :wx_name, :game_id, :wx_status, :created_at, :updated_at
json.url game_setting_url(game_setting, format: :json)