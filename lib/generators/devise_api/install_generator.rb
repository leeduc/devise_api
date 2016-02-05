module DeviseApi
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../../templates', __FILE__)

    def copy_initializer
      template 'devise_api.rb', 'config/initializers/devise_api.rb'
    end

    def copy_migration
      directory 'migrations', 'db/migrate'
    end
  end
end
