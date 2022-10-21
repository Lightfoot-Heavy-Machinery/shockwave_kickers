Rails.application.routes.draw do
  get 'upload/new'
  get 'upload/index'
  get 'upload', to: 'upload#index'
  resources :courses, :students
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "courses#index"

end
