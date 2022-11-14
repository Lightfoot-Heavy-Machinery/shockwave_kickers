Rails.application.routes.draw do
  resources :quizzes, only: [:index, :show, :new, :create]
  get 'home/index'
  get 'upload/index'
  get 'upload', to: 'upload#index'

  post 'quizzes/:id', to:'quizzes#show'

  devise_for :users

  resources :courses do
      post 'courses/:id', to:'courses#show', on: :member
      get 'courses/:id', to:'courses#show', on: :member
  end

  resources :students
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
