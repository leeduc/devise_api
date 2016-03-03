require 'devise_api/rails/routes'

module DeviseApi
  class Engine < ::Rails::Engine
    isolate_namespace DeviseApi
  end

  mattr_accessor :token_lifespan,
                 :token_secretkey,
                 :facebook_key,
                 :facebook_secret_key,
                 :omniauth_prefix,
                 :device,
                 :model,
                 :jwt

  self.token_lifespan = 2.weeks
  self.token_secretkey = 'my$ecretK3y'
  self.omniauth_prefix = '/omniauth'
  self.device = 'device_token'
  self.jwt = 'jwt'

  def self.setup(&_block)
    yield self
  end
end
