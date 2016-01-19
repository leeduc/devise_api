module DeviseApi
  module AuthHelper
    def self.extra_token(token = nil)
      @token = token
      begin
        @header_token = JWT.decode(@token, DeviseApi.token_secretkey, algorithm: 'H256')
        @header_token = @header_token[0] if @header_token[0].present?
      rescue
        raise CheckTokenException, 'Forbidden'
      end

      @detoken = Jwt.check_token(@header_token['uid'])

      fail CheckTokenException, 'Forbidden' if @detoken.nil?

      user = User.find_by email: @detoken.email

      fail CheckTokenException, 'Forbidden' unless user

      user
    end

    def self.generate_token(resource, opts = nil)
      fail GenerateTokenException, 'Email be blank.' unless resource.email.present?
      opts ||= { uid: SecureRandom.hex, exprire: DeviseApi.token_lifespan }
      token = JWT.encode opts, DeviseApi.token_secretkey, 'HS256'

      Jwt.create(
        uid: opts[:uid],
        email: resource.email,
        exprire: DeviseApi.token_lifespan
      )

      token
    end

    class CheckTokenException < Exception
    end

    class GenerateTokenException < Exception
    end
  end
end
