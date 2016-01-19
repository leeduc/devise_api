module DeviseApi
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def create_initializer_file
      copy_file 'devise_api.rb', 'config/initializers/devise_api.rb'
    end
  end
end
