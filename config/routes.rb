RailsStarter::Application.routes.draw do
  namespace :spree do
    resources :expense_categories
  end
  mount Spree::Core::Engine => "/"
  scope module: 'spree' do
    ################################################################################
    # spree api
    ################################################################################

    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :expense_categories
        resources :expense_items
        post '/expense_items/search', to: 'expense_items#index'
        get '/expenses', to: 'expenses#index'

        resources :user_entries #取得用户打卡列表
        post '/user_entries/search', to: 'user_entries#index'

        resources :promotions, only: [:show]

        resources :payment_methods, only: [:index]

        resources :customer_returns, only: [:index]
        resources :reimbursements, only: [:index]

        concern :selling do
          resources :images
          resources :variants
          resources :product_properties

          get :related, on: :member
          resources :relations do
            collection do
              post :update_positions
            end
          end
        end

        resources :products , concerns: :selling do
        end

        resources :selling_services, concerns: :selling do
        end

        resources :selling_cards, concerns: :selling do
        end

        concern :order_routes do
          member do
            put :approve
            put :cancel
            put :empty
            put :apply_coupon_code
          end

          resources :line_items
          resources :payments do
            member do
              put :authorize
              put :capture
              put :purchase
              put :void
              put :credit
            end
          end

          resources :addresses, only: [:show, :update]

          resources :return_authorizations do
            member do
              put :add
              put :cancel
              put :receive
            end
          end
        end

        resources :checkouts, only: [:update], concerns: :order_routes do
          member do
            put :next
            put :advance
          end
        end

        resources :variants do
          resources :images
        end

        resources :option_types do
          resources :option_values
        end
        resources :option_values

        resources :option_values, only: :index

        get '/orders/mine', to: 'orders#mine', as: 'my_orders'
        get '/orders/current', to: 'orders#current', as: 'current_order'

        #resources :orders, concerns: :order_routes

        get '/pos_orders/:id', to: 'pos_orders#show'
        post '/pos_orders', to: 'pos_orders#create'
        get '/pos_orders/find_by_group_number/:group_number', to: 'pos_orders#state_counts'
        get '/pos_orders/state_counts', to: 'pos_orders#state_counts'
        put '/pos_orders/all_step', to: 'pos_orders#all_step'
        put '/pos_orders/:id/one_step', to: 'pos_orders#one_step'
        get '/pos_orders', to: 'pos_orders#index'
        post '/pos_orders/search', to: 'pos_orders#index'
        post '/pos_orders/count', to: 'pos_orders#count'
        put '/pos_orders/:id/cancel', to: 'pos_orders#cancel'
        post '/pos_orders/:id/add_payments', to: 'pos_orders#add_payments'
        delete '/pos_orders/:id', to: 'pos_orders#destroy'

        resources :line_item_groups do
          resources :images
          member do
            put :one_step
            put :cancel #取消
            put :rework #返工
          end
          collection do
            # search/counts, sansack has array paramter, post json is easy.
            post :counts
            put :all_step
            put :all_complete # 交付选择的物品
          end
        end
        post '/line_item_groups/search', to: 'line_item_groups#index'
        put '/line_items/fulfill', to: 'line_items#fulfill'
        #修改除了影响价格之外的信息，目前只有memo
        put '/line_items/:id/update_extra', to: 'line_items#update_extra'

        resources :zones
        resources :countries, only: [:index, :show] do
          resources :states, only: [:index, :show]
        end

        resources :shipments, only: [:create, :update] do
          collection do
            post 'transfer_to_location'
            post 'transfer_to_shipment'
            get :mine
          end

          member do
            put :next
            put :ready
            put :ship
            put :add
            put :remove
          end
        end
        resources :states, only: [:index, :show]

        resources :taxonomies do
          member do
            get :jstree
          end
          resources :taxons do
            member do
              get :jstree
            end
          end
        end

        resources :taxons, only: [:index]

        resources :inventory_units, only: [:show, :update]

        resources :users do
          resources :credit_cards, only: [:index]
          member do
            get :cards
          end
          #搜索店员及打卡记录信息
          collection do
            post :entries
          end
        end
        post '/users/search', to: 'users#index'

        resources :customers do
          member do
            get :cards
            get :statis
          end
          collection do
            get :validate_mobile
          end
        end
        post '/customers/search', to: 'customers#index'

        resources :staffs do

        end

        resources :cards do
          member do
            get :transactions
          end
        end

        resources :properties
        resources :stock_locations do
          resources :stock_movements
          resources :stock_items
        end

        resources :stock_items, only: [:index, :update, :destroy]
        resources :stores

        resources :tags, only: :index

        put '/classifications', to: 'classifications#update', as: :classifications
        get '/taxons/products', to: 'taxons#products', as: :taxon_products

        resources :sale_days do
          collection do
            get 'today'
            post 'day'
            get 'week'
            post 'days'
            post 'total'
          end
        end

      end

      spree_path = Rails.application.routes.url_helpers.try(:spree_path, trailing_slash: true) || '/'

      match 'v:api/*path', to: redirect { |params, request|
        format = ".#{params[:format]}" unless params[:format].blank?
        query  = "?#{request.query_string}" unless request.query_string.blank?

        "#{spree_path}api/v1/#{params[:path]}#{format}#{query}"
      }, via: [:get, :post, :put, :patch, :delete]

      match '*path', to: redirect { |params, request|
        format = ".#{params[:format]}" unless params[:format].blank?
        query  = "?#{request.query_string}" unless request.query_string.blank?

        "#{spree_path}api/v1/#{params[:path]}#{format}#{query}"
      }, via: [:get, :post, :put, :patch, :delete]
    end

    ##############################################################################
    # spree Admin
    ##############################################################################
    # namespace :admin  do
    #   resources :promotions do
    #     resources :promotion_rules
    #     resources :promotion_actions
    #     member do
    #       post :clone
    #     end
    #   end
    #
    #   resources :promotion_categories, except: [:show]
    #
    #   resources :zones
    #
    #   resources :stores do
    #     member do
    #       post :set_default
    #     end
    #   end
    #
    #   resources :countries do
    #     resources :states
    #   end
    #   resources :states
    #   resources :tax_categories
    #
    #   resources :products do
    #     resources :product_properties do
    #       collection do
    #         post :update_positions
    #       end
    #     end
    #     resources :images do
    #       collection do
    #         post :update_positions
    #       end
    #     end
    #     member do
    #       post :clone
    #       get :stock
    #     end
    #     resources :variants do
    #       collection do
    #         post :update_positions
    #       end
    #     end
    #     resources :variants_including_master, only: [:update]
    #   end
    #
    #   resources :option_types do
    #     collection do
    #       post :update_positions
    #       post :update_values_positions
    #     end
    #   end
    #
    #   delete '/option_values/:id', to: 'option_values#destroy', as: :option_value
    #
    #   resources :properties do
    #     collection do
    #       get :filtered
    #     end
    #   end
    #
    #   delete '/product_properties/:id', to: 'product_properties#destroy', as: :product_property
    #
    #   resources :prototypes do
    #     member do
    #       get :select
    #     end
    #
    #     collection do
    #       get :available
    #     end
    #   end
    #
    #   resources :orders, except: [:show] do
    #     member do
    #       get :cart
    #       post :resend
    #       get :open_adjustments
    #       get :close_adjustments
    #       put :approve
    #       put :cancel
    #       put :resume
    #       get :store
    #       put :set_store
    #     end
    #
    #     resources :state_changes, only: [:index]
    #
    #     resource :customer, controller: 'orders/customer_details'
    #     resources :customer_returns, only: [:index, :new, :edit, :create, :update] do
    #       member do
    #         put :refund
    #       end
    #     end
    #
    #     resources :adjustments
    #     resources :return_authorizations do
    #       member do
    #         put :fire
    #       end
    #     end
    #     resources :payments do
    #       member do
    #         put :fire
    #       end
    #
    #       resources :log_entries
    #       resources :refunds, only: [:new, :create, :edit, :update]
    #     end
    #
    #     resources :reimbursements, only: [:index, :create, :show, :edit, :update] do
    #       member do
    #         post :perform
    #       end
    #     end
    #   end
    #
    #   get '/return_authorizations', to: 'return_index#return_authorizations', as: :return_authorizations
    #   get '/customer_returns', to: 'return_index#customer_returns', as: :customer_returns
    #
    #   resource :general_settings do
    #     collection do
    #       post :clear_cache
    #     end
    #   end
    #
    #   resources :return_items, only: [:update]
    #
    #   resources :taxonomies do
    #     collection do
    #       post :update_positions
    #     end
    #     resources :taxons
    #   end
    #
    #   resources :taxons, only: [:index, :show]
    #
    #   resources :reports, only: [:index] do
    #     collection do
    #       get :sales_total
    #       post :sales_total
    #     end
    #   end
    #
    #   resources :reimbursement_types
    #   resources :refund_reasons, except: :show
    #   resources :return_authorization_reasons, except: :show
    #
    #   resources :shipping_methods
    #   resources :shipping_categories
    #   resources :stock_transfers, only: [:index, :show, :new, :create]
    #   resources :stock_locations do
    #     resources :stock_movements, except: [:edit, :update, :destroy]
    #     collection do
    #       post :transfer_stock
    #     end
    #   end
    #
    #   resources :stock_items, only: [:create, :update, :destroy]
    #   resources :store_credit_categories
    #   resources :tax_rates
    #   resources :payment_methods do
    #     collection do
    #       post :update_positions
    #     end
    #   end
    #   resources :roles
    #
    #   resources :users do
    #     member do
    #       get :addresses
    #       put :addresses
    #       put :clear_api_key
    #       put :generate_api_key
    #       get :items
    #       get :orders
    #     end
    #     resources :store_credits
    #   end
    # end

    get Spree.admin_path, to: redirect((Spree.admin_path + '/orders').gsub('//', '/')), as: :admin

    get '/forbidden', to: "base#forbidden", as: :forbidden
  end

  ################################################################################
  # wechatmore game
  ################################################################################


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      ##############################################################################
      # wechat open
      ##############################################################################
      post  'wechat_opens/notify', to: 'wechat_opens#notify'
      get 'wechat_opens/auth', to: 'wechat_opens#auth'

      resource :sessions, only: [:create]
      resource :wechat, only: [:show, :create]

      resources :campaigns
      resources :game_awards, only: [:create, :show, :update, :destroy] do
        resources :players, only:[:index ], controller: :game_award_players  do
        end
      end

      resources :game_rounds do
        member do
          post :reset
          post :start
          post :restart_award
        end
        resources :awards, only:[:index ], controller: :game_awards

        resources :players, only:[:index ], controller: :game_players  do
          collection do
            get :next_by_position
            get :noaward
            get :awarded
          end
        end
      end

      resources :game_players, only: [:create, :show, :update, :destroy] do
      end

      resources :game_award_players, only: [:create, :show, :update, :destroy] do

      end

      #scope path: '/game_round/:game_round_id' do
      #  resources :game_awards, only:[:index ]
      #  resources :game_players, only:[:index ]  do
      #    collection do
      #      get :next_by_position
      #      get :noaward
      #    end
      #  end
      #end
    end
  end

  resources :user_entries #用户打卡记录

  resources :game_round_assets
  resources :game_results
  resources :photographs
  resources :votes
  resources :companies
  resources :stores
  resources :game_days
  resources :game_awards
  resources :game_award_players

  resources :game_rounds, only: [:show] do
    member do
      get :test
      get :create_tester
      get :new_player
      post :create_player

      #故事类游戏的入口。 如：IDO
      get :step
      get :shared #分享链接
      get :check_in
      get :play
      #获奖名单
      get :result
      #奖品设置
      get :awards
      #排行榜
      get :ranking
      get :final_rank #ajax

      #结束报名
      post :check_over
      #开始游戏
      post :start
      #重新开始游戏，保存上次游戏结果，结束的游戏才能重新开始
      post :restart
      #重置游戏，恢复初始状态
      post :reset

    end
  end
  resources :game_players do
    member do
      #我的奖品
      get :award
      #再玩一次
      post :play_again
      #更新分数时，需要返回较多特别数据，所以不适用update
      put :score
    end
  end

  resource :wechat, only: [:show, :create]

   #resources :users
  resources :profiles, only: [:edit, :update, :destroy, :create]


  get '/dashboard' => 'dashboard#index'
  get '/help' => 'help#index'

  ##############################################################################
  # Devise
  ##############################################################################
  devise_for :users, controllers: {
    sessions: 'local_devise/sessions',
    confirmations: 'local_devise/confirmations',
    registrations: 'local_devise/registrations',
    unlocks: 'local_devise/unlocks',
    passwords: 'local_devise/passwords'}

  devise_scope :user do
    # cors, json
    # new_user_session
    get '/users/info', to: 'local_devise/registrations#show'
    post '/users/sign_in_by_entry', to: 'local_devise/sessions#create_by_entry'
    get 'sign_in', to: 'local_devise/sessions#new'
    get 'sign_out', to: 'local_devise/sessions#destroy'

  end

  root to: 'visitors#index'

  get 'devise_usage_report', to: 'devise_usage_log#devise_usage_report'
  get 'close_devise_usage_report', to: 'devise_usage_log#close_devise_usage_report'

  # API 说明文档
  get '/docs/index', to: 'docs#index'


  ##############################################################################
  # Admin
  ##############################################################################
  #namespace :admin do
  #  get '/' => 'home#index'
  #  resources :games do
  #    resources :game_rounds
  #  end
  #  resources :wechat_accounts
  #end

  ##############################################################################
  # Game Case
  ##############################################################################
  # namespace :case do
  #   root to: "game_rounds#index"
  #
  #   resources :campaigns do
  #     resources :game_rounds do
  #       collection do
  #         get :by_code
  #       end
  #     end
  #
  #     member do
  #       get :live_screen
  #       get :live_phone
  #     end
  #   end
  #
  #   #edit, delete, show
  #   resources :game_rounds do
  #     member do
  #       get :players
  #       get :player_results
  #     end
  #   end
  #   resources :game_players
  #   resources :game_settings
  #   resources :stores
  #
  #   resources :wechat_opens, only: [:index] do
  #
  #   end
  #
  #   get 'wechat_bind', to: 'wechat_opens#bind'
  #   get 'wechat_auth', to: 'wechat_opens#auth'
  #
  #
  #   resources :wx_mp_users, except: [:edit, :show, :destroy] do
  #     post :auth, :enable, :disable, :open_oauth, :close_oauth, on: :member
  #     get :qrcode, :oauth, on: :collection
  #   end
  # end

  ##############################################################################
  # 微信公众账号用户
  ##############################################################################
  namespace :mp do
    resources :customers
    resources :wx_followers do
      collection do
        get :order_entry
        post :associate_customer
        get :validate_mobile
      end
    end
    resources :orders do
      collection do
        get :recent
        get :normal
        get :card
      end
    end
  end
  get '/please_subscribe', to: 'mp/wx_followers#please_subscribe', as: 'please_subscribe'
  get '/follower_order_entry', to: 'mp/wx_followers#order_entry', as: 'follower_order_entry'

  ##############################################################################
  # 短信服务接口
  ##############################################################################
  post '/sms', to: 'sms#create', as: :get_sms_code
  post '/sms/validate', to: 'sms#validate', as: :valiate_sms_code
end
