RailsStarter::Application.routes.draw do
################################################################################
# spree api
################################################################################
scope module: 'spree' do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :promotions, only: [:show]

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

      resources :orders, concerns: :order_routes

      post '/pos_orders', to: 'pos_orders#create', as: 'create_pos_orders'
      get '/pos_orders', to: 'pos_orders#index', as: 'pos_orders'
      get '/pos_orders/find_by_group_number/:group_number', to: 'pos_orders#find_by_group_number'
      get '/pos_orders/count', to: 'pos_orders#count', as: 'count_pos_orders'
      put '/pos_orders/all_step', to: 'pos_orders#all_step', as: 'all_step_pos_orders'
      put '/pos_orders/:id/one_step', to: 'pos_orders#one_step', as: 'one_step_pos_orders'

      resources :line_item_groups do
        member do
          put :one_step
        end
        collection do
          # search, sansack has array paramter, post json is easy.
          get :counts
          put :all_step
        end
      end
      post '/line_item_groups/search', to: 'line_item_groups#index'
      put '/line_items/fulfill', to: 'line_items#fulfill'

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
      end
      post '/users/search', to: 'users#index'

      resources :customers do
        member do
          get :cards
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
          get 'selected_day'
          get 'week'
          put 'selected_days'
          get 'total'
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
  end

  root to: 'visitors#index'

  get 'devise_usage_report', to: 'devise_usage_log#devise_usage_report'
  get 'close_devise_usage_report', to: 'devise_usage_log#close_devise_usage_report'

  # API 说明文档
  get '/docs/index', to: 'docs#index'


  ##############################################################################
  # Admin
  ##############################################################################
  namespace :admin do
    get '/' => 'home#index'
    resources :games do
      resources :game_rounds
    end
    resources :wechat_accounts
  end



  ##############################################################################
  # Case
  ##############################################################################
  namespace :case do
    root to: "game_rounds#index"

    resources :campaigns do
      resources :game_rounds do
        collection do
          get :by_code
        end
      end

      member do
        get :live_screen
        get :live_phone
      end
    end

    #edit, delete, show
    resources :game_rounds do
      member do
        get :players
        get :player_results
      end
    end
    resources :game_players
    resources :game_settings
    resources :stores

    resources :wechat_opens, only: [:index] do

    end

    get 'wechat_bind', to: 'wechat_opens#bind'
    get 'wechat_auth', to: 'wechat_opens#auth'


    resources :wx_mp_users, except: [:edit, :show, :destroy] do
      post :auth, :enable, :disable, :open_oauth, :close_oauth, on: :member
      get :qrcode, :oauth, on: :collection
    end
  end


end
