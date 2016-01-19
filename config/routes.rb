DeviseApi::Engine.routes.draw do
  devise_for :users, class_name: 'DeviseApi::User', module: :devise_api, defaults: { format: :json }
  devise_scope :users do
    put 'users/:id/password' => 'users/passwords#update', defaults: { format: 'json' }
    post 'users/sign_out' => 'users/sessions#delete_token', defaults: { format: 'json' }
    post 'users/facebook_sign_up' => 'users#facebook_sign_up', defaults: { format: 'json' }
    resources 'users', path: 'users', only: [:show, :update, :destroy], defaults: { format: 'json' }
  end
end
