Rails.application.routes.draw do
  resources :waffles
  root to: "welcome#index"
end
