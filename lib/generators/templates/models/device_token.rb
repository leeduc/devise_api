class DeviceToken < ActiveRecord::Base
  include DeviseApi::Concerns::DeviceToken
end
