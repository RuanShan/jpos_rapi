RailsStarter::Application.routes.draw do

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

  #devise_for :users, controllers: {
  #  sessions: 'local_devise/sessions',
  #  confirmations: 'local_devise/confirmations',
  #  registrations: 'local_devise/registrations',
  #  unlocks: 'local_devise/unlocks',
  #  passwords: 'local_devise/passwords'}

  root to: 'visitors#index'

  get 'devise_usage_report', to: 'devise_usage_log#devise_usage_report'
  get 'close_devise_usage_report', to: 'devise_usage_log#close_devise_usage_report'
  # API 说明文档
  get '/docs/index', to: 'docs#index'



  namespace :admin do
    get '/' => 'home#index'
    resources :games do
      resources :game_rounds
    end
    resources :wechat_accounts
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      ##############################################################################
      # wechat open
      ##############################################################################
      post  'wechat_opens/notify', to: 'wechat_opens#notify'
      get 'wechat_opens/auth', to: 'wechat_opens#auth'

      #match '/service/:code' => 'weixin#service', via: [:post, :get]
      #match '/message/:app_id/notify' => 'weixin#service', via: [:post, :get]

      resources :campaigns

      resources :users, only: [:index, :create, :show, :update, :destroy]
      resource :sessions, only: [:create]
      resource :wechat, only: [:show, :create]

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
