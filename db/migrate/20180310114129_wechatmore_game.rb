class WechatmoreGame < ActiveRecord::Migration[5.1]

    create_table "campaign_settings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "campaign_id"
      t.string "wx_qrcode_file_name"
      t.string "wx_qrcode_content_type"
      t.integer "wx_qrcode_file_size"
      t.datetime "wx_qrcode_updated_at"
      t.string "wx_name"
      t.integer "wx_status"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["campaign_id"], name: "index_campaign_settings_on_campaign_id"
    end

    create_table "campaigns", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "creator_id"
      t.string "name"
      t.integer "pv", default: 0, null: false
      t.integer "uv", default: 0, null: false
      t.integer "genre", default: 0, null: false
      t.integer "status", default: 0, null: false
      t.string "wx_qrcode_file_name"
      t.string "wx_qrcode_content_type"
      t.integer "wx_qrcode_file_size"
      t.datetime "wx_qrcode_updated_at"
      t.string "wx_name"
      t.integer "wx_status"
      t.datetime "start_at"
      t.datetime "end_at"
      t.string "host"
      t.text "desc"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["creator_id"], name: "index_campaigns_on_creator_id"
    end

    create_table "companies", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "name"
      t.text "desc"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "devise_usage_logs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "user_id", null: false
      t.string "user_ip"
      t.string "role"
      t.string "username"
      t.string "action"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.index ["user_id"], name: "index_devise_usage_logs_on_user_id"
    end

    create_table "game_award_players", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "game_round_id"
      t.integer "game_player_id"
      t.integer "game_award_id"
      t.integer "scores", default: 0, null: false
      t.string "certificate_code", default: "", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "award_time", default: 0, null: false
      t.index ["game_award_id"], name: "index_game_award_players_on_game_award_id"
      t.index ["game_player_id"], name: "index_game_award_players_on_game_player_id"
      t.index ["game_round_id"], name: "index_game_award_players_on_game_round_id"
    end

    create_table "game_awards", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "game_round_id"
      t.string "name"
      t.integer "position"
      t.integer "prize_count", default: 0, null: false
      t.string "prize_name", default: "", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "type"
      t.integer "score", default: 0, null: false
      t.integer "money", default: 0, null: false
      t.float "at_percent", limit: 24, default: 0.0, null: false
      t.integer "day_play_count_limit", default: 0, null: false
      t.integer "day_share_plus", default: 0, null: false
      t.integer "game_cdays_required", default: 0, null: false
      t.integer "game_days_required", default: 0, null: false
      t.string "wx_card_id"
      t.boolean "day_first_achieved_required", default: false, null: false
      t.integer "day_probability", default: 0, null: false
      t.integer "day_prize_count", default: 0, null: false
      t.integer "now_date", default: 0, null: false
      t.integer "now_prize_count", default: 0, null: false
      t.integer "taxon", default: 0, null: false
      t.index ["game_round_id"], name: "index_game_awards_on_game_round_id"
    end

    create_table "game_days", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "game_player_id"
      t.date "day"
      t.integer "play_count", default: 0, null: false
      t.integer "share_count", default: 0, null: false
      t.integer "exercise_count", default: 0, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "visit_count", default: 0, null: false
      t.integer "lot_count", default: 0, null: false
      t.integer "award_count", default: 0, null: false
      t.integer "game_results_count", default: 0, null: false
    end

    create_table "game_players", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "openid", null: false
      t.integer "game_round_id"
      t.integer "wechat_account_id"
      t.string "nickname", limit: 128, default: "", null: false
      t.string "avatar", limit: 300, default: "", null: false
      t.integer "aasm_state", default: 0, null: false
      t.integer "position"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "score", default: 0, null: false
      t.integer "max_score", default: 0, null: false
      t.integer "play_time", default: 0, null: false
      t.string "realname", default: "", null: false
      t.string "cellphone", default: "", null: false
      t.integer "rank", default: 0, null: false
      t.datetime "cache_free_at"
      t.integer "store_id"
      t.date "birth"
      t.integer "votes_count", default: 0, null: false
      t.string "memo"
      t.string "score_token", limit: 64
    end

    create_table "game_results", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.datetime "start_at"
      t.datetime "end_at"
      t.integer "score", default: 0, null: false
      t.integer "game_player_id"
      t.text "trail"
      t.integer "trail_score", default: 0, null: false
      t.string "ip"
      t.string "memo"
      t.integer "status", default: 0, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "realname"
      t.string "cellphone"
      t.string "delivery_cellphone"
      t.integer "delivery_time_option", default: 0, null: false
      t.datetime "delivery_time_at"
      t.string "delivery_sms", limit: 2048
      t.integer "delivery_sms_option", default: 0, null: false
      t.date "delivery_sms_at"
      t.integer "game_round_id"
      t.string "delivery_room"
      t.bigint "game_day_id"
      t.integer "time_span", default: 0, null: false
      t.boolean "is_best", default: false, null: false
      t.index ["game_day_id"], name: "index_game_results_on_game_day_id"
    end

    create_table "game_round_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "name"
      t.text "desc"
      t.integer "game_round_id"
      t.integer "game_player_id"
      t.string "attachment_file_name"
      t.string "attachment_content_type"
      t.integer "attachment_file_size"
      t.datetime "attachment_updated_at"
      t.string "type", limit: 75
      t.string "viewable_type"
      t.bigint "viewable_id"
      t.string "alt"
      t.integer "attachment_width"
      t.integer "attachment_height"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["game_round_id", "type"], name: "index_assets_on_game_round_id_and_type"
      t.index ["viewable_type", "viewable_id"], name: "index_game_round_assets_on_viewable_type_and_viewable_id"
    end

    create_table "game_rounds", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "campaign_id"
      t.integer "game_id"
      t.integer "creator_id"
      t.string "name"
      t.datetime "start_at"
      t.datetime "end_at"
      t.string "preferences"
      t.text "desc"
      t.text "award_desc"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "wx_keyword", default: "", null: false
      t.boolean "contact_required", default: false, null: false
      t.integer "awards", default: 0, null: false
      t.string "award_counts"
      t.integer "display_players", default: 0, null: false
      t.integer "duration", null: false
      t.integer "gear", null: false
      t.integer "countdown", default: 0, null: false
      t.integer "aasm_state", default: 0, null: false
      t.integer "play_times", default: 0, null: false
      t.datetime "close_at"
      t.datetime "open_at"
      t.integer "award_times", default: 0, null: false
      t.string "code", default: "", null: false
      t.integer "screen_style", default: 0, null: false
      t.datetime "cache_free_at"
      t.string "appid", limit: 64
      t.integer "company_id"
      t.integer "relative_game_round_id"
      t.index ["campaign_id"], name: "index_game_rounds_on_campaign_id"
      t.index ["creator_id"], name: "index_game_rounds_on_creator_id"
      t.index ["game_id"], name: "index_game_rounds_on_game_id"
    end

    create_table "games", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "name"
      t.integer "code", default: 0
      t.text "desc"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "wx_oauth2_scope", default: 0, null: false
    end

    create_table "photographs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "game_player_id"
      t.string "type"
      t.string "name"
      t.text "desc"
      t.string "image_file_name"
      t.string "image_content_type"
      t.integer "image_file_size"
      t.datetime "image_updated_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "stores", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "name"
      t.integer "player_limit", default: 0, null: false
      t.string "address"
      t.integer "company_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "email", limit: 128, default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "payment_password", default: "", null: false
      t.string "reset_password_token", limit: 128
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "confirmation_token", limit: 128
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string "unconfirmed_email"
      t.integer "failed_attempts", default: 0, null: false
      t.string "unlock_token", limit: 128
      t.datetime "locked_at"
      t.string "image_url"
      t.string "role", default: "guest"
      t.string "username", limit: 64, default: "", null: false
      t.string "api_key", default: "", limit: 48,  null: false
      t.integer "company_id"
      t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
      t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
      t.index ["username"], name: "index_users_on_username", unique: true

      #copy from spree_users
      t.string "password_salt", limit: 128
      t.string "remember_token"
      t.string "persistence_token"
      t.string "perishable_token"
      t.datetime "last_request_at"
      t.integer "ship_address_id"
      t.integer "bill_address_id"
      t.string "authentication_token"
      t.boolean :is_staff, null: false, default: false
      t.string "mobile"
      t.datetime "birth"
      t.string "address"
      t.string "memo"
      t.integer "store_id"
      t.datetime "deleted_at"

      t.timestamps null: false

      t.index ["bill_address_id"], name: "index_spree_users_on_bill_address_id"
      t.index ["deleted_at"], name: "index_spree_users_on_deleted_at"
      t.index ["ship_address_id"], name: "index_spree_users_on_ship_address_id"
      t.index ["store_id", "email"], name: "email_idx_unique", unique: true
      t.index ["api_key"], name: "index_spree_users_on_api_key"

    end


    create_table "customers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "email", limit: 128, default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "payment_password", default: "", null: false
      t.string "reset_password_token", limit: 128
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "confirmation_token", limit: 128
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string "unconfirmed_email"
      t.integer "failed_attempts", default: 0, null: false
      t.string "unlock_token", limit: 128
      t.datetime "locked_at"
      t.string "image_url"
      t.string "role", default: "guest"
      t.string "username", limit: 64, default: "", null: false
      t.integer "company_id"

      #copy from spree_users
      t.string "password_salt", limit: 128
      t.string "remember_token"
      t.string "persistence_token"
      t.string "perishable_token"
      t.datetime "last_request_at"
      t.integer "ship_address_id"
      t.integer "bill_address_id"
      t.string "authentication_token"
      t.boolean :is_staff, null: false, default: false
      t.string "mobile", limit: 24, null: false
      t.datetime "birth"
      t.string "address"
      t.string "memo"
      t.integer "store_id"
      t.integer "gender", default: 0, null: false
      t.datetime "deleted_at"
      t.integer :created_by_id #这个客户的创建者是谁

      t.timestamps null: false

      t.index ["mobile", "store_id"], unique: true
      t.index ["deleted_at"], name: "index_spree_users_on_deleted_at"

    end


    create_table "votes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "game_player_id"
      t.string "openid"
      t.date "voted_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "wechat_accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "uniacid", default: 0, null: false
      t.string "token", limit: 32, default: "", null: false
      t.string "access_token", default: "", null: false
      t.string "encoding_aes_key", default: "", null: false
      t.integer "status", default: 0, null: false
      t.string "name", limit: 32, default: "", null: false
      t.string "account", limit: 32, default: "", null: false
      t.string "original_id", limit: 50, default: "", null: false
      t.string "signature", limit: 100, default: "", null: false
      t.string "country", limit: 24, default: "", null: false
      t.string "province", limit: 24, default: "", null: false
      t.string "city", limit: 24, default: "", null: false
      t.string "username", limit: 32, default: "", null: false
      t.string "password", limit: 32, default: "", null: false
      t.string "appid", limit: 50, default: "", null: false
      t.string "appsecret", limit: 50, default: "", null: false
      t.string "subscribeurl", limit: 120, default: "", null: false
      t.string "auth_refresh_token", default: "", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "wechat_sessions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "openid", limit: 64, null: false
      t.string "hash_store"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["openid"], name: "index_wechat_sessions_on_openid", unique: true
    end

    create_table "wx_component_secrets", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "ticket"
      t.string "access_token"
      t.string "preauthcode"
      t.datetime "ticket_updated_at"
      t.datetime "access_token_updated_at"
      t.datetime "preauthcode_updated_at"
      t.integer "access_token_expires_in"
      t.integer "preauthcode_expires_in"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "wx_follower_tokens", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "openid"
      t.string "wx_token"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "wx_followers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.integer "subscribe"
      t.string "openid"
      t.string "nickname"
      t.integer "sex"
      t.string "language"
      t.string "city"
      t.string "province"
      t.string "country"
      t.string "headimgurl"
      t.datetime "subscribe_time"
      t.string "unionid"
      t.string "remark"
      t.integer "groupid"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "wx_mp_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
      t.string "appid"
      t.string "access_token"
      t.string "refresh_token"
      t.string "nick_name"
      t.string "head_img"
      t.string "user_name"
      t.string "alias"
      t.string "wx_token"
      t.integer "service_type_id"
      t.string "verify_type_info"
      t.datetime "access_token_updated_at"
      t.datetime "access_token_expires_in"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "company_id"
      t.integer "creator_id"
      t.string "nickname"
      t.string "qrcode_url"
      t.string "auth_code"
      t.text "func_info"
      t.integer "expires_in", default: 0, null: false
      t.integer "service_type", default: 0, null: false
      t.integer "bind_type", default: 0, null: false
      t.string "openid"
      t.string "url"
      t.string "token"
      t.integer "status", default: 0, null: false
      t.string "app_secret"
      t.string "app_id"
      t.integer "encrypt_mode", default: 0
      t.string "encoding_aes_key"
      t.boolean "is_oauth", default: false, null: false
      t.integer "binds_count", default: 0
    end

    add_foreign_key "campaigns", "users", column: "creator_id"
    add_foreign_key "game_rounds", "campaigns"
    add_foreign_key "game_rounds", "games"
    add_foreign_key "game_rounds", "users", column: "creator_id"

end
