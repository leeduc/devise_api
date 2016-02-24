module DeviseApi
  module AuthHelper
    def self.extra_token(token = nil)
      Thread.current[:token] = token
      begin
        Thread.current[:header_token] = JWT.decode(Thread.current[:token], DeviseApi.token_secretkey, algorithm: 'H256')
        Thread.current[:header_token] = Thread.current[:header_token][0] if Thread.current[:header_token][0].present?
      rescue
        raise CheckTokenException, 'Forbidden'
      end

      Thread.current[:detoken] = Jwt.check_token(Thread.current[:header_token]['uid'])

      fail CheckTokenException, 'Forbidden' if Thread.current[:detoken].nil?

      user = User.find_by email: Thread.current[:detoken].email

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

    def _header_token
      Thread.current[:header_token]
    end

    def _token
      Thread.current[:token]
    end

    def _detoken
      Thread.current[:detoken]
    end

    class CheckTokenException < Exception
    end

    class GenerateTokenException < Exception
    end
  end
end
