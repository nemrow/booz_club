Rails.application.routes.draw do
  post 'search', to: 'search#new'
  post 'init_call', to: 'call_handler#init_call'
  post 'handle_response', to: 'call_handler#handle_response'

  root 'main#index'
end
