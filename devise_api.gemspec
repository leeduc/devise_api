$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'devise_api/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'devise_api'
  s.version     = DeviseApi::VERSION
  s.authors     = ['Le Duc']
  s.email       = ['lee.duc55@gmail.com']
  s.homepage    = ''
  s.summary     = 'Devise Api'
  s.description = 'Using Devise response to restful'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.2.4'
  s.add_dependency 'devise', '~> 3.5.2'
  s.add_dependency 'jwt', '~> 1.5.2'
  s.add_dependency 'rails_param'
  s.add_dependency 'date_validator'
  s.add_dependency 'config'
  s.add_dependency 'koala'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'factory_girl_rails'
end
