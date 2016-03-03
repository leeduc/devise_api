module DeviseApi::Concerns::TokenHelper
  extend ActiveSupport::Concern
  include DeviseApi::AuthHelper

  included do
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    before_action :check_token
  end

  protected

    def check_token
      return throw_error unless request.headers['Access-Token'].present?

      begin
        user = AuthHelper.extra_token request.headers['Access-Token']
      rescue StandardError
        return throw_error
      end

      sign_in(:user, user, store: false, bypass: false)
    end

    def resource_class(m = nil)
      if m
        mapping = Devise.mappings[m]
      else
        mapping = Devise.mappings[resource_name] || Devise.mappings.values.first
      end

      mapping.to
    end

  private

    def render_error(message, code = :bad_request)
      @resource = OpenStruct.new(errors: message)
      render template: 'users/error', status: code
    end

    def throw_error(message = 'Forbidden', code = :forbidden)
      render 'layouts/error', status: code, locals: {
        object: OpenStruct.new(message: message)
      }
    end
end
