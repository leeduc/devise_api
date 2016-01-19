require 'carrierwave/orm/activerecord'
module DeviseApi
  class User < ActiveRecord::Base
    self.table_name = 'users'
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :confirmable
    attr_accessor :token
    has_many :listings
    has_many :device_tokens
    # mount_uploader :avatar, ListingUploader

    validates :email, presence: true, email: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :password, presence: { on: :create }, confirmation: true, length: { minimum: 6, on: :create }
    validates :password_confirmation, presence: true, if: '!password.nil?'

    def self.find_oauth(data)
      find_by 'email = ? OR facebook_id = ?', data[:email], data[:facebook_id]
    end

    def send_reset_password_instructions(opts = nil)
      token = set_reset_password_token
      opts ||= {}

      # fall back to 'default' config name
      opts[:client_config] ||= 'default'

      send_devise_notification(:reset_password_instructions, token, opts)

      token
    end
  end
end
