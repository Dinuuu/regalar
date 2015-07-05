Regalar::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root 'application#index'
  get '/about', to: 'application#about'

  resources :gift_items, only: [:index, :new, :create] do
    resources :comments, except: [:edit, :update]
  end
  # Users Routes
  
  resources :users do
    resources :gift_items, controller: 'user_gift_items', except: [:destroy] do
      
      resources :gift_requests, controller: 'organization_gift_requests', only: [:new, :create]
      
      resources :gift_requests, controller: 'organization_gift_requests', only: [:show]
    end
    member do
      get :edit_password
      patch :update_password
      resources :gift_requests, controller: 'user_gift_requests', only: [] do
        collection do
          get :confirmed
          get :pending
        end
      end
    end
    collection do
      resources :gift_requests, controller: 'user_gift_requests', only: [:show] do
        member do
          delete :cancel
          post :confirm
        end
      end
      resources :donations, controller: 'user_donations', only: [:destroy], as: 'cancel_donation'
    end 
  end

  # End Users Routes

  # Organizations Routes

  resources :organizations do

    resources :wish_items do
      member do
        put :pause
        put :resume
        resources :donations, controller: 'user_donations', only: [:new, :create]
      end
      resources :comments, except: [:edit, :update]
      resources :donations, controller: 'user_donations', only: [:show]
    end


    collection do
      get :list
      resources :gift_requests, controller: 'organization_gift_requests', only: [:destroy], as: 'cancel_gift_request'
    end

    resources :comments, except: [:edit, :update]

    # OrganizationDonations Routes
    resources :donations, controller: 'organization_donations', only: [:show, :index] do
      member do
        put :confirm
        delete :cancel
      end
      collection do
        get :confirmed
        get :pending
      end
    end
    # End OrganizationDonations Routes
  end

  # End Organizations Routes

  resources :wish_items, only: [] do  
    collection do
      get :list
    end
  end
 
  # Mails Preview Routes

  mount MailPreview => 'mail_view' if Rails.env.development?

  # End Mails Preview Routes

  # Image Storage

  mount PostgresqlLoStreamer::Engine => '/user_avatar', as: 'user_avatar'
  mount PostgresqlLoStreamer::Engine => '/campaign_main_image', as: 'campaign_main_image'

  # End Image Storage

end
