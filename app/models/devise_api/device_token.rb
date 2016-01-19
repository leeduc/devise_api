module DeviseApi
  class DeviceToken < ActiveRecord::Base
    belongs_to :user

    validates :user, presence: true
    validates :token, presence: true
    validates :device, presence: true

    def self.save_device_token(token, user_id, device = 0)
      DeviceToken.delete_token token

      abc = {
        token: token,
        device: device.to_i,
        user_id: user_id
      }

      record = DeviceToken.new(abc)

      record.save!(validate: false)
    end

    def self.delete_token(token)
      where(token: token).destroy_all
    end
  end
end
