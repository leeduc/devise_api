module DeviseApi
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../../templates', __FILE__)

    argument :user_class, type: :string, default: 'User'
    argument :mount_path, type: :string, default: 'user'

    def copy_initializer
      template 'devise_api.rb', 'config/initializers/devise_api.rb'
    end

    def copy_migrations
      migration_template 'migrations/devise_api_create_users.rb.erb',
                         "db/migrate/devise_api_create_#{user_class.pluralize.underscore}.rb"
      migration_template 'migrations/devise_api_create_jwt_table.rb',
                         'db/migrate/devise_api_create_jwt_table.rb'
      migration_template 'migrations/devise_api_create_device_token.rb',
                         'db/migrate/devise_api_create_device_token.rb'
    end

    def create_user_model
      fname = "app/models/#{user_class.underscore}.rb"
      template('models/device_token.rb', 'app/models/device_token.rb')
      template('models/jwt.rb', 'app/models/jwt.rb')
      return template('models/user.rb', fname) unless File.exist?(File.join(destination_root, fname))

      inclusion = 'include DeviseApi::Concerns::User'
      return if parse_file_for_line(fname, inclusion)
      inject_into_file fname, after: "class #{user_class} < ActiveRecord::Base\n" do <<-'RUBY'
      # Include default devise modules.
      devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable,
            :confirmable, :omniauthable
      RUBY
      end
    end

    def add_route_mount
      f    = 'config/routes.rb'
      str  = "mount_devise_api_for '#{user_class}', at: '#{mount_path}'"

      if File.exist?(File.join(destination_root, f))
        line = parse_file_for_line(f, 'mount_devise_api_for')

        if line
          existing_user_class = true
        else
          line = 'Rails.application.routes.draw do'
          existing_user_class = false
        end

        if parse_file_for_line(f, str)
          say_status('skipped', "Routes already exist for #{user_class} at #{mount_path}")
        else
          insert_after_line(f, line, str)

          if existing_user_class
            scoped_routes = '' \
                            "as :#{user_class.underscore} do\n" \
                            "    # Define routes for #{user_class} within this block.\n" \
                            "  end\n"
            insert_after_line(f, str, scoped_routes)
          end
        end
      else
        say_status('skipped',
                   "config/routes.rb not found. Add \"mount_devise_api_for '#{user_class}',
                   at: '#{mount_path}'\" to your routes file.")
      end
    end

    private

    def self.next_migration_number(_path)
      sleep 1
      Time.now.utc.strftime('%Y%m%d%H%M%S')
    end

    def insert_after_line(filename, line, str)
      gsub_file filename, /(#{Regexp.escape(line)})/mi do |match|
        "#{match}\n  #{str}"
      end
    end

    def parse_file_for_line(filename, str)
      match = false

      File.open(File.join(destination_root, filename)) do |f|
        f.each_line { |line| match = line if line =~ /(#{Regexp.escape(str)})/mi }
      end
      match
    end
  end
end
