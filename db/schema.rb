# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180408053417) do

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

  create_table "ckeditor_assets", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id", default: 0, null: false
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id", "assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["site_id", "assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "companies", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
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

  create_table "friendly_id_slugs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_friendly_id_slugs_on_deleted_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: { slug: 20, sluggable_type: 20, scope: 20 }
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: { slug: 20, sluggable_type: 20 }
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
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

  create_table "sessions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "spree_ad_hoc_option_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "option_type_id"
    t.integer "position", default: 0, null: false
    t.string "price_modifier_type"
    t.boolean "is_required", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_ad_hoc_option_values", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ad_hoc_option_type_id"
    t.integer "option_value_id"
    t.integer "position"
    t.boolean "selected"
    t.decimal "price_modifier", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "cost_price_modifier", precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_ad_hoc_option_values_line_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "line_item_id"
    t.integer "ad_hoc_option_value_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_ad_hoc_variant_exclusions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_addresses", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "zipcode"
    t.string "phone"
    t.string "state_name"
    t.string "alternative_phone"
    t.string "company"
    t.integer "state_id"
    t.integer "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "city_id", default: 0
    t.string "city_name"
    t.integer "district_id", default: 0
    t.index ["country_id"], name: "index_spree_addresses_on_country_id"
    t.index ["firstname"], name: "index_addresses_on_firstname"
    t.index ["lastname"], name: "index_addresses_on_lastname"
    t.index ["state_id"], name: "index_spree_addresses_on_state_id"
  end

  create_table "spree_adjustments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "source_id"
    t.string "source_type"
    t.integer "adjustable_id"
    t.string "adjustable_type"
    t.decimal "amount", precision: 10, scale: 2
    t.string "label"
    t.boolean "mandatory"
    t.boolean "eligible", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "state"
    t.integer "order_id", null: false
    t.boolean "included", default: false
    t.index ["adjustable_id", "adjustable_type"], name: "index_spree_adjustments_on_adjustable_id_and_adjustable_type"
    t.index ["eligible"], name: "index_spree_adjustments_on_eligible"
    t.index ["order_id"], name: "index_spree_adjustments_on_order_id"
    t.index ["source_id", "source_type"], name: "index_spree_adjustments_on_source_id_and_source_type"
  end

  create_table "spree_alipay_transactions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "trade_no", limit: 64
    t.float "total_fee", limit: 24
    t.string "buyer_id", limit: 16
    t.string "buyer_email", limit: 100
    t.string "payment_type", limit: 4
    t.string "is_success", limit: 1
    t.string "trade_status"
    t.string "refund_status"
    t.string "batch_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_assets", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "viewable_id"
    t.string "viewable_type"
    t.integer "attachment_width"
    t.integer "attachment_height"
    t.integer "attachment_file_size"
    t.integer "position"
    t.string "attachment_content_type"
    t.string "attachment_file_name"
    t.string "type", limit: 75
    t.datetime "attachment_updated_at"
    t.text "alt"
    t.integer "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["position"], name: "index_spree_assets_on_position"
    t.index ["viewable_id"], name: "index_assets_on_viewable_id"
    t.index ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type"
  end

  create_table "spree_calculators", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type"
    t.integer "calculable_id"
    t.string "calculable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "preferences"
    t.datetime "deleted_at"
    t.index ["calculable_id", "calculable_type"], name: "index_spree_calculators_on_calculable_id_and_calculable_type"
    t.index ["deleted_at"], name: "index_spree_calculators_on_deleted_at"
    t.index ["id", "type"], name: "index_spree_calculators_on_id_and_type"
  end

  create_table "spree_cities", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "abbr"
    t.integer "state_id"
  end

  create_table "spree_comment_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "applies_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_comments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title", limit: 50, default: ""
    t.text "comment"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.integer "user_id"
    t.string "email", limit: 50, default: ""
    t.string "cellphone", limit: 50, default: ""
    t.integer "comment_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commentable_id"], name: "index_spree_comments_on_commentable_id"
    t.index ["commentable_type"], name: "index_spree_comments_on_commentable_type"
    t.index ["user_id"], name: "index_spree_comments_on_user_id"
  end

  create_table "spree_countries", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "iso_name"
    t.string "iso"
    t.string "iso3"
    t.string "name"
    t.integer "numcode"
    t.boolean "states_required", default: false
    t.datetime "updated_at"
    t.boolean "zipcode_required", default: true
    t.index ["iso_name"], name: "index_spree_countries_on_iso_name"
    t.index ["name"], name: "index_spree_countries_on_name"
  end

  create_table "spree_credit_cards", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "month"
    t.string "year"
    t.string "cc_type"
    t.string "last_digits"
    t.integer "address_id"
    t.string "gateway_customer_profile_id"
    t.string "gateway_payment_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.integer "user_id"
    t.integer "payment_method_id"
    t.boolean "default", default: false, null: false
    t.index ["address_id"], name: "index_spree_credit_cards_on_address_id"
    t.index ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id"
    t.index ["user_id"], name: "index_spree_credit_cards_on_user_id"
  end

  create_table "spree_customer_returns", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "number"
    t.integer "stock_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["number"], name: "index_spree_customer_returns_on_number", unique: true
    t.index ["stock_location_id"], name: "index_spree_customer_returns_on_stock_location_id"
  end

  create_table "spree_customers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "encrypted_password", limit: 128
    t.string "password_salt", limit: 128
    t.string "email"
    t.string "remember_token"
    t.string "persistence_token"
    t.string "reset_password_token"
    t.string "perishable_token"
    t.integer "sign_in_count", default: 0, null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "login"
    t.integer "ship_address_id"
    t.integer "bill_address_id"
    t.string "authentication_token"
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.datetime "remember_created_at"
    t.string "spree_api_key", limit: 48
    t.datetime "deleted_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["bill_address_id"], name: "index_spree_users_on_bill_address_id"
    t.index ["deleted_at"], name: "index_spree_users_on_deleted_at"
    t.index ["ship_address_id"], name: "index_spree_users_on_ship_address_id"
    t.index ["site_id", "email"], name: "email_idx_unique", unique: true
    t.index ["spree_api_key"], name: "index_spree_users_on_spree_api_key"
  end

  create_table "spree_customizable_product_options", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_customization_type_id"
    t.integer "position"
    t.string "presentation", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_customized_product_options", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_customization_id"
    t.integer "customizable_product_option_id"
    t.string "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "customization_image"
  end

  create_table "spree_districts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "abbr"
    t.integer "city_id"
  end

  create_table "spree_editors", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "slug", limit: 200, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_excluded_ad_hoc_option_values", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ad_hoc_variant_exclusion_id"
    t.integer "ad_hoc_option_value_id"
  end

  create_table "spree_gateways", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type"
    t.string "name"
    t.text "description"
    t.boolean "active", default: true
    t.string "environment", default: "development"
    t.string "server", default: "test"
    t.boolean "test_mode", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "preferences"
    t.index ["active"], name: "index_spree_gateways_on_active"
    t.index ["test_mode"], name: "index_spree_gateways_on_test_mode"
  end

  create_table "spree_html_attributes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title", default: "", null: false
    t.string "css_name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "pvalues", default: "", null: false
    t.string "pvalues_desc", default: "", null: false
    t.string "punits", default: "", null: false
    t.boolean "neg_ok", default: false, null: false
    t.integer "default_value", limit: 2, default: 0, null: false
    t.string "pvspecial", limit: 7, default: "", null: false
    t.index ["slug"], name: "index_spree_html_attributes_on_slug", unique: true
  end

  create_table "spree_inventory_units", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "state"
    t.integer "variant_id"
    t.integer "order_id"
    t.integer "shipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "pending", default: true
    t.integer "line_item_id"
    t.integer "quantity", default: 1
    t.integer "original_return_item_id"
    t.index ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id"
    t.index ["order_id"], name: "index_inventory_units_on_order_id"
    t.index ["original_return_item_id"], name: "index_spree_inventory_units_on_original_return_item_id"
    t.index ["shipment_id"], name: "index_inventory_units_on_shipment_id"
    t.index ["variant_id"], name: "index_inventory_units_on_variant_id"
  end

  create_table "spree_line_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.integer "order_id"
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "currency"
    t.decimal "cost_price", precision: 10, scale: 2
    t.integer "tax_category_id"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "pre_tax_amount", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "non_taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["order_id"], name: "index_spree_line_items_on_order_id"
    t.index ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id"
    t.index ["variant_id"], name: "index_spree_line_items_on_variant_id"
  end

  create_table "spree_log_entries", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "source_id"
    t.string "source_type"
    t.text "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.index ["source_id", "source_type"], name: "index_spree_log_entries_on_source_id_and_source_type"
  end

  create_table "spree_oauth_accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "provider"
    t.integer "uid"
    t.text "info"
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "provider"], name: "index_spree_oauth_accounts_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_spree_oauth_accounts_on_user_id"
  end

  create_table "spree_option_type_prototypes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
    t.index ["option_type_id"], name: "index_spree_option_type_prototypes_on_option_type_id"
    t.index ["prototype_id", "option_type_id"], name: "spree_option_type_prototypes_prototype_id_option_type_id"
    t.index ["prototype_id"], name: "index_spree_option_type_prototypes_on_prototype_id"
  end

  create_table "spree_option_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 100
    t.string "presentation", limit: 100
    t.integer "position", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.index ["name"], name: "index_spree_option_types_on_name"
    t.index ["position"], name: "index_spree_option_types_on_position"
  end

  create_table "spree_option_value_variants", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
    t.index ["option_value_id"], name: "index_spree_option_value_variants_on_option_value_id"
    t.index ["variant_id", "option_value_id"], name: "index_option_values_variants_on_variant_id_and_option_value_id", unique: true
    t.index ["variant_id"], name: "index_spree_option_value_variants_on_variant_id"
  end

  create_table "spree_option_values", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "position"
    t.string "name"
    t.string "presentation"
    t.integer "option_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_spree_option_values_on_name"
    t.index ["option_type_id"], name: "index_spree_option_values_on_option_type_id"
    t.index ["position"], name: "index_spree_option_values_on_position"
  end

  create_table "spree_order_promotions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order_id"
    t.integer "promotion_id"
    t.index ["order_id"], name: "index_spree_order_promotions_on_order_id"
    t.index ["promotion_id", "order_id"], name: "index_spree_order_promotions_on_promotion_id_and_order_id"
    t.index ["promotion_id"], name: "index_spree_order_promotions_on_promotion_id"
  end

  create_table "spree_orders", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "number", limit: 32
    t.decimal "item_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "state"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "user_id"
    t.datetime "completed_at"
    t.integer "bill_address_id"
    t.integer "ship_address_id"
    t.decimal "payment_total", precision: 10, scale: 2, default: "0.0"
    t.string "shipment_state"
    t.string "payment_state"
    t.string "email"
    t.text "special_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.string "currency"
    t.string "last_ip_address"
    t.integer "created_by_id"
    t.string "channel", default: "spree"
    t.decimal "shipment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "item_count", default: 0
    t.integer "approver_id"
    t.datetime "approved_at"
    t.boolean "confirmation_delivered", default: false
    t.boolean "considered_risky", default: false
    t.string "guest_token"
    t.datetime "canceled_at"
    t.integer "canceler_id"
    t.integer "store_id"
    t.integer "state_lock_version", default: 0, null: false
    t.integer "user_terminal_id"
    t.decimal "taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "non_taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.boolean "is_pos", default: false
    t.index ["approver_id"], name: "index_spree_orders_on_approver_id"
    t.index ["bill_address_id"], name: "index_spree_orders_on_bill_address_id"
    t.index ["canceler_id"], name: "index_spree_orders_on_canceler_id"
    t.index ["completed_at"], name: "index_spree_orders_on_completed_at"
    t.index ["confirmation_delivered"], name: "index_spree_orders_on_confirmation_delivered"
    t.index ["considered_risky"], name: "index_spree_orders_on_considered_risky"
    t.index ["created_by_id"], name: "index_spree_orders_on_created_by_id"
    t.index ["guest_token"], name: "index_spree_orders_on_guest_token"
    t.index ["is_pos"], name: "index_spree_orders_on_is_pos"
    t.index ["number", "store_id"], name: "index_spree_orders_on_number_and_store_id", unique: true
    t.index ["number"], name: "index_spree_orders_on_number"
    t.index ["ship_address_id"], name: "index_spree_orders_on_ship_address_id"
    t.index ["store_id"], name: "index_spree_orders_on_store_id"
    t.index ["user_id", "created_by_id"], name: "index_spree_orders_on_user_id_and_created_by_id"
  end

  create_table "spree_page_layouts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id", limit: 3, default: 0
    t.integer "root_id", limit: 3
    t.integer "parent_id", limit: 3
    t.integer "lft", limit: 2, default: 0, null: false
    t.integer "rgt", limit: 2, default: 0, null: false
    t.string "title", limit: 200, default: "", null: false
    t.string "slug", limit: 200, default: "", null: false
    t.integer "section_id", limit: 3, default: 0
    t.integer "section_instance", limit: 2, default: 0, null: false
    t.string "section_context", limit: 64, default: "", null: false
    t.string "data_source", limit: 32, default: "", null: false
    t.string "data_filter", limit: 32, default: "", null: false
    t.boolean "is_enabled", default: true, null: false
    t.integer "copy_from_root_id", default: 0, null: false
    t.boolean "is_full_html", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "data_source_param", default: ""
    t.integer "content_param", default: 0, null: false
    t.integer "depth"
    t.string "css_class"
    t.string "content_css_class"
    t.integer "stylish", default: 0, null: false
    t.integer "template_theme_id", default: 0, null: false
    t.integer "copy_from_id", default: 0, null: false
    t.string "data_source_order_by"
    t.string "image_param", limit: 24
    t.string "effect_param", limit: 32
  end

  create_table "spree_param_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "editor_id", limit: 3, default: 0, null: false
    t.integer "position", limit: 3, default: 0
    t.string "slug", limit: 200, default: "", null: false
    t.boolean "is_enabled", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_param_values", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "page_layout_root_id", limit: 2, default: 0, null: false
    t.integer "page_layout_id", limit: 2, default: 0, null: false
    t.integer "section_param_id", limit: 2, default: 0, null: false
    t.integer "theme_id", limit: 2, default: 0, null: false
    t.string "pvalue", limit: 4096
    t.string "unset"
    t.string "computed_pvalue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_payment_capture_events", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.integer "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id"
  end

  create_table "spree_payment_methods", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type"
    t.string "name"
    t.text "description"
    t.boolean "active", default: true
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "display_on", default: "both"
    t.integer "site_id"
    t.boolean "auto_capture"
    t.text "preferences"
    t.integer "user_terminal_id"
    t.integer "position", default: 0
    t.index ["id", "type"], name: "index_spree_payment_methods_on_id_and_type"
  end

  create_table "spree_payments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "order_id"
    t.integer "source_id"
    t.string "source_type"
    t.integer "payment_method_id"
    t.string "state"
    t.string "response_code"
    t.string "avs_response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "number"
    t.string "cvv_response_code"
    t.string "cvv_response_message"
    t.index ["number"], name: "index_spree_payments_on_number", unique: true
    t.index ["order_id"], name: "index_spree_payments_on_order_id"
    t.index ["payment_method_id"], name: "index_spree_payments_on_payment_method_id"
    t.index ["source_id", "source_type"], name: "index_spree_payments_on_source_id_and_source_type"
  end

  create_table "spree_post_products", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "post_id"
    t.integer "product_id"
    t.integer "position"
  end

  create_table "spree_posts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id", default: 0
    t.string "title"
    t.string "slug"
    t.string "teaser"
    t.datetime "posted_at"
    t.text "body"
    t.string "author"
    t.boolean "live", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position", default: 0
    t.string "cover_file_name"
    t.string "cover_content_type"
    t.integer "cover_file_size", default: 0
    t.datetime "cover_updated_at"
    t.string "meta_title"
    t.string "meta_description"
    t.string "meta_keywords"
  end

  create_table "spree_posts_taxons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "post_id"
    t.integer "taxon_id"
    t.integer "position"
  end

  create_table "spree_preferences", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "value"
    t.string "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id", default: 0
    t.index ["site_id", "key"], name: "index_spree_preferences_on_key", unique: true
  end

  create_table "spree_prices", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "currency"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_spree_prices_on_deleted_at"
    t.index ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency"
    t.index ["variant_id"], name: "index_spree_prices_on_variant_id"
  end

  create_table "spree_product_customization_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "presentation"
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_product_customization_types_products", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_customization_type_id"
    t.integer "product_id"
  end

  create_table "spree_product_customizations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "line_item_id"
    t.integer "product_customization_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_product_option_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "position"
    t.integer "product_id"
    t.integer "option_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["option_type_id"], name: "index_spree_product_option_types_on_option_type_id"
    t.index ["position"], name: "index_spree_product_option_types_on_position"
    t.index ["product_id"], name: "index_spree_product_option_types_on_product_id"
  end

  create_table "spree_product_promotion_rules", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
    t.index ["product_id"], name: "index_products_promotion_rules_on_product_id"
    t.index ["promotion_rule_id", "product_id"], name: "index_products_promotion_rules_on_promotion_rule_and_product"
  end

  create_table "spree_product_properties", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "value"
    t.integer "product_id"
    t.integer "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position", default: 0
    t.index ["position"], name: "index_spree_product_properties_on_position"
    t.index ["product_id"], name: "index_product_properties_on_product_id"
    t.index ["property_id"], name: "index_spree_product_properties_on_property_id"
  end

  create_table "spree_products", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string "slug"
    t.text "meta_description"
    t.string "meta_keywords"
    t.integer "tax_category_id"
    t.integer "shipping_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.integer "theme_id", default: 0, null: false
    t.boolean "promotionable", default: true
    t.string "meta_title"
    t.string "summary"
    t.datetime "discontinue_on"
    t.index ["available_on"], name: "index_spree_products_on_available_on"
    t.index ["deleted_at"], name: "index_spree_products_on_deleted_at"
    t.index ["discontinue_on"], name: "index_spree_products_on_discontinue_on"
    t.index ["name"], name: "index_spree_products_on_name"
    t.index ["shipping_category_id"], name: "index_spree_products_on_shipping_category_id"
    t.index ["site_id", "slug"], name: "index_spree_products_on_slug", unique: true
    t.index ["tax_category_id"], name: "index_spree_products_on_tax_category_id"
  end

  create_table "spree_products_global_taxons", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "taxon_id"
    t.index ["product_id"], name: "index_spree_products_global_taxons_on_product_id"
    t.index ["taxon_id"], name: "index_spree_products_global_taxons_on_taxon_id"
  end

  create_table "spree_products_taxons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id"
    t.integer "taxon_id"
    t.integer "position"
    t.index ["position"], name: "index_spree_products_taxons_on_position"
    t.index ["product_id"], name: "index_spree_products_taxons_on_product_id"
    t.index ["taxon_id"], name: "index_spree_products_taxons_on_taxon_id"
  end

  create_table "spree_promotion_action_line_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity", default: 1
    t.index ["promotion_action_id"], name: "index_spree_promotion_action_line_items_on_promotion_action_id"
    t.index ["variant_id"], name: "index_spree_promotion_action_line_items_on_variant_id"
  end

  create_table "spree_promotion_actions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "promotion_id"
    t.integer "position"
    t.string "type"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at"
    t.index ["id", "type"], name: "index_spree_promotion_actions_on_id_and_type"
    t.index ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id"
  end

  create_table "spree_promotion_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "code"
  end

  create_table "spree_promotion_rule_taxons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "taxon_id"
    t.integer "promotion_rule_id"
    t.index ["promotion_rule_id"], name: "index_spree_promotion_rule_taxons_on_promotion_rule_id"
    t.index ["taxon_id"], name: "index_spree_promotion_rule_taxons_on_taxon_id"
  end

  create_table "spree_promotion_rule_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
    t.index ["promotion_rule_id"], name: "index_promotion_rules_users_on_promotion_rule_id"
    t.index ["user_id", "promotion_rule_id"], name: "index_promotion_rules_users_on_user_id_and_promotion_rule_id"
  end

  create_table "spree_promotion_rules", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "promotion_id"
    t.integer "user_id"
    t.integer "product_group_id"
    t.string "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "code"
    t.text "preferences"
    t.index ["product_group_id"], name: "index_promotion_rules_on_product_group_id"
    t.index ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id"
    t.index ["user_id"], name: "index_promotion_rules_on_user_id"
  end

  create_table "spree_promotions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description"
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string "name"
    t.string "type"
    t.integer "usage_limit"
    t.string "match_policy", default: "all"
    t.string "code"
    t.boolean "advertise", default: false
    t.string "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "promotion_category_id"
    t.index ["advertise"], name: "index_spree_promotions_on_advertise"
    t.index ["code"], name: "index_spree_promotions_on_code"
    t.index ["expires_at"], name: "index_spree_promotions_on_expires_at"
    t.index ["id", "type"], name: "index_spree_promotions_on_id_and_type"
    t.index ["promotion_category_id"], name: "index_spree_promotions_on_promotion_category_id"
    t.index ["starts_at"], name: "index_spree_promotions_on_starts_at"
  end

  create_table "spree_properties", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "presentation", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.index ["name"], name: "index_spree_properties_on_name"
  end

  create_table "spree_property_prototypes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "prototype_id"
    t.integer "property_id"
    t.index ["property_id"], name: "index_spree_property_prototypes_on_property_id"
    t.index ["prototype_id", "property_id"], name: "index_property_prototypes_on_prototype_id_and_property_id", unique: true
    t.index ["prototype_id"], name: "index_spree_property_prototypes_on_prototype_id"
  end

  create_table "spree_prototype_taxons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "taxon_id"
    t.integer "prototype_id"
    t.index ["prototype_id", "taxon_id"], name: "index_spree_prototype_taxons_on_prototype_id_and_taxon_id"
    t.index ["prototype_id"], name: "index_spree_prototype_taxons_on_prototype_id"
    t.index ["taxon_id"], name: "index_spree_prototype_taxons_on_taxon_id"
  end

  create_table "spree_prototypes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
  end

  create_table "spree_refund_reasons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.boolean "active", default: true
    t.boolean "mutable", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_spree_refund_reasons_on_name"
  end

  create_table "spree_refunds", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "payment_id"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "refund_reason_id"
    t.integer "reimbursement_id"
    t.index ["payment_id"], name: "index_spree_refunds_on_payment_id"
    t.index ["refund_reason_id"], name: "index_refunds_on_refund_reason_id"
    t.index ["reimbursement_id"], name: "index_spree_refunds_on_reimbursement_id"
  end

  create_table "spree_reimbursement_credits", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "reimbursement_id"
    t.integer "creditable_id"
    t.string "creditable_type"
    t.index ["creditable_id", "creditable_type"], name: "index_reimbursement_credits_on_creditable_id_and_type"
    t.index ["reimbursement_id"], name: "index_spree_reimbursement_credits_on_reimbursement_id"
  end

  create_table "spree_reimbursement_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.boolean "active", default: true
    t.boolean "mutable", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "type"
    t.index ["name"], name: "index_spree_reimbursement_types_on_name"
    t.index ["type"], name: "index_spree_reimbursement_types_on_type"
  end

  create_table "spree_reimbursements", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "number"
    t.string "reimbursement_status"
    t.integer "customer_return_id"
    t.integer "order_id"
    t.decimal "total", precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["customer_return_id"], name: "index_spree_reimbursements_on_customer_return_id"
    t.index ["number"], name: "index_spree_reimbursements_on_number", unique: true
    t.index ["order_id"], name: "index_spree_reimbursements_on_order_id"
  end

  create_table "spree_relation_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.string "applies_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
  end

  create_table "spree_relations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "relation_type_id"
    t.integer "relatable_id"
    t.string "relatable_type"
    t.integer "related_to_id"
    t.string "related_to_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "discount_amount", precision: 8, scale: 2, default: "0.0"
    t.integer "position"
  end

  create_table "spree_return_authorization_reasons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.boolean "active", default: true
    t.boolean "mutable", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_spree_return_authorization_reasons_on_name"
  end

  create_table "spree_return_authorizations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "number"
    t.string "state"
    t.integer "order_id"
    t.text "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "stock_location_id"
    t.integer "return_authorization_reason_id"
    t.index ["number"], name: "index_spree_return_authorizations_on_number", unique: true
    t.index ["order_id"], name: "index_spree_return_authorizations_on_order_id"
    t.index ["return_authorization_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id"
    t.index ["stock_location_id"], name: "index_spree_return_authorizations_on_stock_location_id"
  end

  create_table "spree_return_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "return_authorization_id"
    t.integer "inventory_unit_id"
    t.integer "exchange_variant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "pre_tax_amount", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "included_tax_total", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "additional_tax_total", precision: 12, scale: 4, default: "0.0", null: false
    t.string "reception_status"
    t.string "acceptance_status"
    t.integer "customer_return_id"
    t.integer "reimbursement_id"
    t.text "acceptance_status_errors"
    t.integer "preferred_reimbursement_type_id"
    t.integer "override_reimbursement_type_id"
    t.boolean "resellable", default: true, null: false
    t.index ["customer_return_id"], name: "index_return_items_on_customer_return_id"
    t.index ["exchange_variant_id"], name: "index_spree_return_items_on_exchange_variant_id"
    t.index ["inventory_unit_id"], name: "index_spree_return_items_on_inventory_unit_id"
    t.index ["override_reimbursement_type_id"], name: "index_spree_return_items_on_override_reimbursement_type_id"
    t.index ["preferred_reimbursement_type_id"], name: "index_spree_return_items_on_preferred_reimbursement_type_id"
    t.index ["reimbursement_id"], name: "index_spree_return_items_on_reimbursement_id"
    t.index ["return_authorization_id"], name: "index_spree_return_items_on_return_authorization_id"
  end

  create_table "spree_role_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "role_id"
    t.integer "user_id"
    t.index ["role_id"], name: "index_spree_role_users_on_role_id"
    t.index ["user_id"], name: "index_spree_role_users_on_user_id"
  end

  create_table "spree_roles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.index ["name"], name: "index_spree_roles_on_name"
  end

  create_table "spree_section_params", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "section_root_id"
    t.integer "section_id"
    t.integer "section_piece_param_id"
    t.string "default_value"
    t.boolean "is_enabled", default: true
    t.string "disabled_ha_ids", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_section_piece_params", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "section_piece_id", limit: 2, default: 0, null: false
    t.integer "editor_id", limit: 2, default: 0, null: false
    t.integer "param_category_id", limit: 2, default: 0, null: false
    t.integer "position", limit: 2, default: 0, null: false
    t.string "pclass"
    t.string "class_name", default: "", null: false
    t.string "html_attribute_ids", limit: 1000, default: "", null: false
    t.string "param_conditions", limit: 1000
    t.boolean "is_editable", default: true
    t.string "editable_condition", default: ""
  end

  create_table "spree_section_pieces", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title", limit: 100, null: false
    t.string "slug", limit: 100, null: false
    t.string "html", limit: 12000, default: "", null: false
    t.string "css", limit: 8000, default: "", null: false
    t.string "js", limit: 60, default: "", null: false
    t.boolean "is_root", default: false, null: false
    t.boolean "is_container", default: false, null: false
    t.boolean "is_selectable", default: false, null: false
    t.string "resources", limit: 20, default: "", null: false
    t.string "usage", limit: 10, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_clickable", default: false, null: false
    t.integer "for_terminal", limit: 1, default: 0, null: false
    t.index ["slug"], name: "index_spree_section_pieces_on_slug", unique: true
  end

  create_table "spree_section_texts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "lang"
    t.string "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_sections", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id", limit: 3, default: 0, null: false
    t.integer "root_id", limit: 3
    t.integer "parent_id", limit: 3
    t.integer "lft", limit: 2, default: 0, null: false
    t.integer "rgt", limit: 2, default: 0, null: false
    t.string "title", limit: 64, default: "", null: false
    t.string "slug", limit: 64, default: "", null: false
    t.integer "section_piece_id", limit: 3, default: 0
    t.integer "section_piece_instance", limit: 2, default: 0
    t.boolean "is_enabled", default: true, null: false
    t.string "global_events", limit: 200, default: "", null: false
    t.string "subscribed_global_events", limit: 200, default: "", null: false
    t.integer "content_param", default: 0, null: false
    t.integer "for_terminal", limit: 1, default: 0, null: false
    t.string "usage", limit: 24
  end

  create_table "spree_shipments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "tracking"
    t.string "number"
    t.decimal "cost", precision: 10, scale: 2, default: "0.0"
    t.datetime "shipped_at"
    t.integer "order_id"
    t.integer "address_id"
    t.string "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "stock_location_id"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "pre_tax_amount", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "non_taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["address_id"], name: "index_spree_shipments_on_address_id"
    t.index ["number"], name: "index_spree_shipments_on_number", unique: true
    t.index ["order_id"], name: "index_spree_shipments_on_order_id"
    t.index ["stock_location_id"], name: "index_spree_shipments_on_stock_location_id"
  end

  create_table "spree_shipping_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.index ["name"], name: "index_spree_shipping_categories_on_name"
  end

  create_table "spree_shipping_method_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipping_method_id", null: false
    t.integer "shipping_category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true
    t.index ["shipping_category_id"], name: "index_spree_shipping_method_categories_on_shipping_category_id"
    t.index ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id"
  end

  create_table "spree_shipping_method_zones", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipping_method_id"
    t.integer "zone_id"
    t.index ["shipping_method_id"], name: "index_spree_shipping_method_zones_on_shipping_method_id"
    t.index ["zone_id"], name: "index_spree_shipping_method_zones_on_zone_id"
  end

  create_table "spree_shipping_methods", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "display_on"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.string "tracking_url"
    t.string "admin_name"
    t.integer "tax_category_id"
    t.string "code"
    t.index ["deleted_at"], name: "index_spree_shipping_methods_on_deleted_at"
    t.index ["tax_category_id"], name: "index_spree_shipping_methods_on_tax_category_id"
  end

  create_table "spree_shipping_rates", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipment_id"
    t.integer "shipping_method_id"
    t.boolean "selected", default: false
    t.decimal "cost", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "tax_rate_id"
    t.index ["selected"], name: "index_spree_shipping_rates_on_selected"
    t.index ["shipment_id", "shipping_method_id"], name: "spree_shipping_rates_join_index", unique: true
    t.index ["shipment_id"], name: "index_spree_shipping_rates_on_shipment_id"
    t.index ["shipping_method_id"], name: "index_spree_shipping_rates_on_shipping_method_id"
    t.index ["tax_rate_id"], name: "index_spree_shipping_rates_on_tax_rate_id"
  end

  create_table "spree_sites", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "layout"
    t.integer "parent_id"
    t.string "short_name"
    t.integer "rgt"
    t.integer "lft"
    t.boolean "has_sample", default: false
    t.boolean "loading_sample", default: false
    t.integer "index_page", default: 0
    t.integer "theme_id", default: 0
    t.integer "template_release_id", default: 0
    t.integer "foreign_theme_id", default: 0, null: false
    t.boolean "support_mobile", default: false, null: false
    t.boolean "allow_ssl_in_production", default: false
    t.boolean "allow_ssl_in_development_and_test", default: false
    t.boolean "allow_ssl_in_staging", default: false
    t.boolean "check_for_spree_alerts", default: false
    t.boolean "display_currency", default: false
    t.boolean "hide_cents", default: false
    t.string "currency", default: "CNY"
    t.string "currency_symbol_position", default: "before"
    t.string "currency_decimal_mark", default: "."
    t.string "currency_thousands_separator", default: ","
    t.integer "status", default: 0
  end

  create_table "spree_state_changes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "previous_state"
    t.integer "stateful_id"
    t.integer "user_id"
    t.string "stateful_type"
    t.string "next_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.index ["stateful_id", "stateful_type"], name: "index_spree_state_changes_on_stateful_id_and_stateful_type"
  end

  create_table "spree_states", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "abbr"
    t.integer "country_id"
    t.datetime "updated_at"
    t.index ["country_id"], name: "index_spree_states_on_country_id"
  end

  create_table "spree_stock_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "stock_location_id"
    t.integer "variant_id"
    t.integer "count_on_hand", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "backorderable", default: false
    t.datetime "deleted_at"
    t.index ["backorderable"], name: "index_spree_stock_items_on_backorderable"
    t.index ["deleted_at"], name: "index_spree_stock_items_on_deleted_at"
    t.index ["stock_location_id", "variant_id"], name: "stock_item_by_loc_and_var_id"
    t.index ["stock_location_id"], name: "index_spree_stock_items_on_stock_location_id"
    t.index ["variant_id"], name: "index_spree_stock_items_on_variant_id"
  end

  create_table "spree_stock_locations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.integer "state_id"
    t.string "state_name"
    t.integer "country_id"
    t.string "zipcode"
    t.string "phone"
    t.boolean "active", default: true
    t.boolean "backorderable_default", default: false
    t.boolean "propagate_all_variants", default: true
    t.string "admin_name"
    t.boolean "default", default: false, null: false
    t.index ["active"], name: "index_spree_stock_locations_on_active"
    t.index ["backorderable_default"], name: "index_spree_stock_locations_on_backorderable_default"
    t.index ["country_id"], name: "index_spree_stock_locations_on_country_id"
    t.index ["propagate_all_variants"], name: "index_spree_stock_locations_on_propagate_all_variants"
    t.index ["state_id"], name: "index_spree_stock_locations_on_state_id"
  end

  create_table "spree_stock_movements", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "stock_item_id"
    t.integer "quantity", default: 0
    t.string "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "originator_id"
    t.string "originator_type"
    t.index ["originator_id", "originator_type"], name: "index_stock_movements_on_originator_id_and_originator_type"
    t.index ["stock_item_id"], name: "index_spree_stock_movements_on_stock_item_id"
  end

  create_table "spree_stock_transfers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "type"
    t.string "reference"
    t.integer "source_location_id"
    t.integer "destination_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "number"
    t.index ["destination_location_id"], name: "index_spree_stock_transfers_on_destination_location_id"
    t.index ["number"], name: "index_spree_stock_transfers_on_number", unique: true
    t.index ["source_location_id"], name: "index_spree_stock_transfers_on_source_location_id"
  end

  create_table "spree_store_assets", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "viewable_id"
    t.string "viewable_type"
    t.integer "attachment_width"
    t.integer "attachment_height"
    t.integer "attachment_file_size"
    t.integer "position"
    t.string "attachment_content_type"
    t.string "attachment_file_name"
    t.string "type", limit: 75
    t.datetime "attachment_updated_at"
    t.text "alt"
    t.index ["viewable_id"], name: "index_store_assets_on_viewable_id"
    t.index ["viewable_type", "type"], name: "index_store_assets_on_viewable_type_and_type"
  end

  create_table "spree_store_credit_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_store_credit_events", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "store_credit_id", null: false
    t.string "action", null: false
    t.decimal "amount", precision: 8, scale: 2
    t.string "authorization_code", null: false
    t.decimal "user_total_amount", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "originator_id"
    t.string "originator_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["originator_id", "originator_type"], name: "spree_store_credit_events_originator"
    t.index ["store_credit_id"], name: "index_spree_store_credit_events_on_store_credit_id"
  end

  create_table "spree_store_credit_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority"], name: "index_spree_store_credit_types_on_priority"
  end

  create_table "spree_store_credits", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "created_by_id"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "amount_used", precision: 8, scale: 2, default: "0.0", null: false
    t.text "memo"
    t.datetime "deleted_at"
    t.string "currency"
    t.decimal "amount_authorized", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "originator_id"
    t.string "originator_type"
    t.integer "type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_store_credits_on_deleted_at"
    t.index ["originator_id", "originator_type"], name: "spree_store_credits_originator"
    t.index ["type_id"], name: "index_spree_store_credits_on_type_id"
    t.index ["user_id"], name: "index_spree_store_credits_on_user_id"
  end

  create_table "spree_stores", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "url"
    t.text "meta_description"
    t.text "meta_keywords"
    t.string "seo_title"
    t.string "mail_from_address"
    t.string "default_currency"
    t.string "code"
    t.boolean "default", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id", default: 0
    t.string "map_lat"
    t.string "map_lng"
    t.string "map_title"
    t.string "map_content"
    t.boolean "designable", default: false
    t.integer "index_page_id", default: 0, null: false
    t.integer "theme_id", default: 0, null: false
    t.integer "template_release_id", default: 0, null: false
    t.boolean "is_public", default: false
    t.boolean "enable_mail_delivery", default: false
    t.string "mail_host"
    t.integer "mail_port", default: 25
    t.string "secure_connection_type", default: "None"
    t.string "mail_auth_type", default: "None"
    t.string "mail_domain"
    t.string "smtp_username"
    t.string "smtp_encrypted_password"
    t.string "mail_bcc"
    t.string "file_theme_name"
    t.string "wx_appid"
    t.string "wx_secret"
    t.string "wx_token"
    t.index ["code"], name: "index_spree_stores_on_code"
    t.index ["default"], name: "index_spree_stores_on_default"
    t.index ["url"], name: "index_spree_stores_on_url"
  end

  create_table "spree_taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_spree_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "spree_taggings_idx", unique: true
    t.index ["tag_id"], name: "index_spree_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "spree_taggings_idy"
    t.index ["taggable_id"], name: "index_spree_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_spree_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_spree_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_spree_taggings_on_tagger_id"
  end

  create_table "spree_tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_spree_tags_on_name", unique: true
  end

  create_table "spree_tax_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_default", default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.string "tax_code"
    t.index ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at"
    t.index ["is_default"], name: "index_spree_tax_categories_on_is_default"
  end

  create_table "spree_tax_rates", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "amount", precision: 8, scale: 5
    t.integer "zone_id"
    t.integer "tax_category_id"
    t.boolean "included_in_price", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.boolean "show_rate_in_label", default: true
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at"
    t.index ["included_in_price"], name: "index_spree_tax_rates_on_included_in_price"
    t.index ["show_rate_in_label"], name: "index_spree_tax_rates_on_show_rate_in_label"
    t.index ["tax_category_id"], name: "index_spree_tax_rates_on_tax_category_id"
    t.index ["zone_id"], name: "index_spree_tax_rates_on_zone_id"
  end

  create_table "spree_taxonomies", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.integer "position", default: 0
    t.index ["position"], name: "index_spree_taxonomies_on_position"
  end

  create_table "spree_taxons", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "parent_id"
    t.integer "position", default: 0
    t.string "name", null: false
    t.string "permalink"
    t.integer "taxonomy_id"
    t.integer "lft"
    t.integer "rgt"
    t.string "icon_file_name"
    t.string "icon_content_type"
    t.integer "icon_file_size"
    t.datetime "icon_updated_at"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.string "meta_title"
    t.string "meta_description"
    t.string "meta_keywords"
    t.integer "depth"
    t.integer "page_context", default: 0, null: false
    t.string "html_attributes"
    t.integer "replaced_by", default: 0, null: false
    t.boolean "is_clickable", default: true, null: false
    t.string "tooltips"
    t.integer "stylish", default: 0, null: false
    t.index ["lft"], name: "index_spree_taxons_on_lft"
    t.index ["name"], name: "index_spree_taxons_on_name"
    t.index ["parent_id"], name: "index_taxons_on_parent_id"
    t.index ["permalink"], name: "index_taxons_on_permalink"
    t.index ["position"], name: "index_spree_taxons_on_position"
    t.index ["rgt"], name: "index_spree_taxons_on_rgt"
    t.index ["taxonomy_id"], name: "index_taxons_on_taxonomy_id"
  end

  create_table "spree_template_files", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "theme_id"
    t.integer "attachment_width"
    t.integer "attachment_height"
    t.integer "attachment_file_size"
    t.string "attachment_content_type"
    t.string "attachment_file_name"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.string "alt"
  end

  create_table "spree_template_releases", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 24, null: false
    t.integer "theme_id", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_template_texts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id", default: 0, null: false
    t.string "name"
    t.text "body"
    t.string "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["permalink"], name: "index_spree_template_texts_on_permalink"
  end

  create_table "spree_template_themes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id", default: 0
    t.integer "page_layout_root_id", default: 0, null: false
    t.integer "release_id", default: 0
    t.string "title", limit: 64, default: "", null: false
    t.string "slug", limit: 64, default: "", null: false
    t.string "assigned_resource_ids", limit: 2048
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_public", default: false, null: false
    t.integer "for_terminal", limit: 1, default: 0, null: false
    t.integer "master_id", default: 0, null: false
    t.datetime "last_released_at"
    t.datetime "last_changed_at"
    t.integer "store_id"
    t.string "locale", limit: 24
    t.integer "home_page_id"
    t.integer "copy_from_id", default: 0, null: false
    t.integer "user_terminal_id"
    t.integer "renderer", default: 0, null: false
  end

  create_table "spree_trackers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "analytics_id"
    t.boolean "active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.string "name", limit: 24
    t.integer "engine", default: 0, null: false
    t.index ["active"], name: "index_spree_trackers_on_active"
  end

  create_table "spree_user_terminals", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 64
    t.string "medium_width", limit: 128
  end

  create_table "spree_variants", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "sku", default: "", null: false
    t.decimal "weight", precision: 8, scale: 2, default: "0.0"
    t.decimal "height", precision: 8, scale: 2
    t.decimal "width", precision: 8, scale: 2
    t.decimal "depth", precision: 8, scale: 2
    t.datetime "deleted_at"
    t.boolean "is_master", default: false
    t.integer "product_id"
    t.decimal "cost_price", precision: 10, scale: 2
    t.integer "position"
    t.string "cost_currency"
    t.boolean "track_inventory", default: true
    t.integer "tax_category_id"
    t.datetime "updated_at", null: false
    t.datetime "discontinue_on"
    t.datetime "created_at", null: false
    t.index ["deleted_at"], name: "index_spree_variants_on_deleted_at"
    t.index ["discontinue_on"], name: "index_spree_variants_on_discontinue_on"
    t.index ["is_master"], name: "index_spree_variants_on_is_master"
    t.index ["position"], name: "index_spree_variants_on_position"
    t.index ["product_id"], name: "index_spree_variants_on_product_id"
    t.index ["sku"], name: "index_spree_variants_on_sku"
    t.index ["tax_category_id"], name: "index_spree_variants_on_tax_category_id"
    t.index ["track_inventory"], name: "index_spree_variants_on_track_inventory"
  end

  create_table "spree_zone_members", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "zoneable_id"
    t.string "zoneable_type"
    t.integer "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["zone_id"], name: "index_spree_zone_members_on_zone_id"
    t.index ["zoneable_id", "zoneable_type"], name: "index_spree_zone_members_on_zoneable_id_and_zoneable_type"
  end

  create_table "spree_zones", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.boolean "default_tax", default: false
    t.integer "zone_members_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "site_id"
    t.string "kind"
    t.index ["default_tax"], name: "index_spree_zones_on_default_tax"
    t.index ["kind"], name: "index_spree_zones_on_kind"
  end

  create_table "stores", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.integer "player_limit", default: 0, null: false
    t.string "address"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context"
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "email", limit: 128, default: "", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.string "api_key", limit: 48, default: "", null: false
    t.integer "company_id"
    t.string "password_salt", limit: 128
    t.string "remember_token"
    t.string "persistence_token"
    t.string "perishable_token"
    t.datetime "last_request_at"
    t.integer "ship_address_id"
    t.integer "bill_address_id"
    t.string "authentication_token"
    t.integer "store_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_spree_users_on_api_key"
    t.index ["bill_address_id"], name: "index_spree_users_on_bill_address_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_spree_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["ship_address_id"], name: "index_spree_users_on_ship_address_id"
    t.index ["store_id", "email"], name: "email_idx_unique", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
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
