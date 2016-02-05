module DeviseApi
  class Jwt < ActiveRecord::Base
    self.table_name = 'jwts'
    def self.check_token(uid)
      find_by uid: uid
    end
  end
end
