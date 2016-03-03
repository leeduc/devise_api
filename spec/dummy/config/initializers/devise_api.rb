# Add initialization content here
DeviseApi.setup do |config|
  config.token_lifespan = 1.week
  config.model = 'user'
end
