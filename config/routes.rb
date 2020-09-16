Rails.application.routes.draw do
  root 'users#index' # ADD THIS LINE!
  resources :users
end
