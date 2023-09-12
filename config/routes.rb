Rails.application.routes.draw do
  use_doorkeeper
  jsonapi_resources :users, only: %i[index show create]
end
