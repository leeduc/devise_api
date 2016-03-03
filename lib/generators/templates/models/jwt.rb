class Jwt < ActiveRecord::Base
  include DeviseApi::Concerns::Jwt
end
