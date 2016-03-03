module DeviseApi::Concerns::User
  extend ActiveSupport::Concern

  included do
    if self.method_defined?(:devise_modules)
      devise_modules.delete(:omniauthable)
    else
      devise :database_authenticatable, :registerable,
             :recoverable, :trackable, :validatable, :confirmable
    end

    attr_accessor :token
    has_many DeviseApi.device.to_sym

    def self.find_oauth(data)
      find_by 'email = ? OR facebook_id = ?', data[:email], data[:facebook_id]
    end
  end
end
