Regalar::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root 'application#index'
  get '/about', to: 'application#about'

  resources :gift_items, only: [:index]
  # Users Routes

  resources :users do
    resources :gift_items, controller: 'user_gift_items', except: [:destroy]
    member do
      get :edit_password
      patch :update_password
    end
    collection do
      resources :donations, controller: 'user_donations', only: [:destroy], as: 'cancel_donation'
    end 
  end

  # End Users Routes

  # Organizations Routes

  resources :organizations do

    resources :wish_items do
      member do
        post :stop
        post :resume
        resources :donations, controller: 'user_donations', only: [:new, :create]
      end
      resources :comments, except: [:edit, :update]
      resources :donations, controller: 'user_donations', only: [:show]
    end


    collection do
      get :list
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

  # Campaigns Routes

  resources :campaigns do
    collection do
      get :search
      post :search
      get :landing
    end
    member do
      post :approve
      get :configure
      post :configure_step2
      post :configure_step3
    end
  end

  resources :purchases do
    collection do
      get :success_mercadopago_callback
      get :pending_mercadopago_callback
      get :failure_mercadopago_callback
    end
  end

  # End Campaigns Routes
  
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
