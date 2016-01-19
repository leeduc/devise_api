module DeviseApi
  class ApplicationController < ActionController::Base
    include DeviseApi::AuthHelper

    protect_from_forgery with: :null_session
    before_action :check_token
    skip_before_action :verify_authenticity_token

    protected

      def check_token
        return throw_403 unless request.headers['Access-Token'].present?

        begin
          user = AuthHelper.extra_token request.headers['Access-Token']
        rescue StandardError
          return throw_403
        end

        sign_in(:user, user, store: false, bypass: false)
      end

    private

      def throw_403
        render 'layouts/error', status: 403, locals: {
          object: OpenStruct.new(message: 'Forbidden')
        }
      end
  end
end
