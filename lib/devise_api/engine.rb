module DeviseApi
  class Engine < ::Rails::Engine
    isolate_namespace DeviseApi
  end

  mattr_accessor :token_lifespan,
                 :token_secretkey,
                 :facebook_key,
                 :facebook_secret_key

  self.token_lifespan = 2.weeks
  self.token_secretkey = 'my$ecretK3y'

  def self.setup(&_block)
    yield self
  end
end
