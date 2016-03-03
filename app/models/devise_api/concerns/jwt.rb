module DeviseApi::Concerns::Jwt
  extend ActiveSupport::Concern

  def self.check_token(uid)
    find_by uid: uid
  end
end
