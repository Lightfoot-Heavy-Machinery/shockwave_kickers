Rails.application.routes.draw do
  get 'home/index'
  get 'upload/index'
  get 'upload', to: 'upload#index'
  devise_for :users

  resources :courses, :students do
      collection do
          get 'list'
      end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  devise_scope :user do
    authenticated :user do
        root 'home#index', as: :authenticated_root
    end

    unauthenticated do
        root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
