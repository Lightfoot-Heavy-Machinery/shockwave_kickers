Rails.application.routes.draw do
  get 'semesters/index'
  get 'semesters/show'
  get 'semesters/new'
  get 'semesters/edit'
  resources :courses, :students
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "courses#index"

end
