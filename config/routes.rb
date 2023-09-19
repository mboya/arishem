Rails.application.routes.draw do
  use_doorkeeper
  jsonapi_resources :users, only: %i[index show create]

  post 'pesa/validate'
  post 'pesa/confirm'
  post 'pesa/queue_timeout'
  post 'pesa/result'
  post 'pesa/call_back'
  get 'pesa/pesa_token'
end
