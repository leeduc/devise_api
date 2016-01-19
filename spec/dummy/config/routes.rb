Rails.application.routes.draw do
  mount DeviseApi::Engine => '/devise_api'
end
