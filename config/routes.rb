Rails.application.routes.draw do
  root to: "home#index", defaults: {format: :json}
  namespace :api, { defaults: { format: :json } } do
    resources :users, only: [:index, :create] do
      collection do
        put :update_user
      end
    end
    
    # 用户登录
    post 'check_openid' => 'login#check_openid'

    # 首页请求数据
    get 'index' => 'index#index'
    get 'header' => 'index#header'
    get 'statement/:id' => 'index#bill'

    get 'icons/assets' => 'icon#assets'
    get 'icons/categories' => 'icon#categories'

    resources :budgets do
      collection do
        get :parent
      end
    end
    
    resources :transfer, only: [:show]

    resources :pre_order, only: [:index, :show, :create, :update, :destroy] do
      member do
        put :mark
      end
    end

    resources :message, only: [:index, :show] do
      collection do 
        get :test
      end
    end

    # 账单
    resources :statements do
      collection do
        get :assets
        get :categories
        get :category_frequent
        get :asset_frequent
        get :detail
      end
    end

    # 图表
    resources :chart, only: [:index] do
      collection do
        get :spread
      end
    end
    
    # 钱包
    resources :wallet do
      collection do
        get :information
        get :detail
        put :surplus
      end
    end
    # 分类
    resources :categories do
      collection do
        get :parent
      end
    end

    resources :assets do
      collection do
        get :parent
      end
    end

    resources :super_statements do
      collection do
        get :time
        get :list
        get :filter
      end
    end

    resources :super_chart, only: [:index] do
      collection do
        get :line_chart
      end
    end

    resources :settings do 
      collection do 
        post :feedback
        post :upload
        get :covers
        post :set_cover
      end
    end

    post 'upload' => 'upload#upload'
  end

  # match "*path", to: "errors#show", via: :all
end
