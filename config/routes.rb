Regalar::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root 'application#index'
  get '/about', to: 'application#about'

  # Users Routes

  resources :users do
    member do
      get :edit_password
      patch :update_password
    end
    collection do
      resources :donations, controller: 'user_donations', only: [:destroy]
    end
  end

  # End Users Routes

  # Organizations Routes

  resources :organizations do

    resources :wish_items do
      resources :donations, controller: 'user_donations', only: [:new, :create, :show]
    end

    collection do
      get :list
    end

    resources :comments, except: [:edit, :update]

    resources :campaigns do
      resources :milestones do
        member do
          get :achieve
          patch :confirm_achieved
        end
      end
      resources :contributions do
        collection do
          get :landing
          post :anonymous
        end
      end
      resources :comments, except: [:edit, :update]
    end

    # OrganizationDonations Routes
    resources :donations, controller: 'organization_donations', only: [:show, :index] do
      member do
        put :confirm
        delete :cancel
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

  # #Wish Lists Routes
  # resources :wish_items do
  #   collection do
  #     get :list
  #   end
  # end     

  # Mails Preview Routes

  mount MailPreview => 'mail_view' if Rails.env.development?

  # End Mails Preview Routes

  # Image Storage

  mount PostgresqlLoStreamer::Engine => '/user_avatar', as: 'user_avatar'
  mount PostgresqlLoStreamer::Engine => '/campaign_main_image', as: 'campaign_main_image'

  # End Image Storage

end
