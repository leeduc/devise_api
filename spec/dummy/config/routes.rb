Rails.application.routes.draw do
  mount_devise_api_for 'User', at: 'user'
  # mount DeviseApi::Engine => '/devise_api'
end
