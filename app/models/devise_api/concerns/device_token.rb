module DeviseApi::Concerns::DeviceToken
  extend ActiveSupport::Concern

  def self.save_device_token(token, user_id, device = 0)
    delete_token token

    record = new(
      token: token,
      device: device.to_i,
      user_id: user_id
    )

    record.save!(validate: false)
  end

  def self.delete_token(token)
    where(token: token).destroy_all
  end

  included do
    belongs_to DeviseApi.model
  end
end
