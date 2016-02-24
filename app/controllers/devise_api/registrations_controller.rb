module DeviseApi
  class RegistrationsController < Devise::RegistrationsController
    skip_before_filter :verify_authenticity_token
    before_action :check_token, except: [:create]

    def create
      @resource = resource_class.new(sign_up_params)
      @resource.email = create_set_email

      return render_validate_error unless @resource.save
      @token = AuthHelper.generate_token @resource
      render_create_success
    rescue ActiveRecord::RecordNotUnique
      @resource.errors.add(:email, 'already exists')
      render_create_error_email_already_exists
    rescue
      render_create_error
    end

    protected

      def create_set_email
        return sign_up_params[:email].try :downcase if resource_class.case_insensitive_keys.include?(:email)
        sign_up_params[:email]
      end

      def sign_up_params
        p = devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name
        params.permit(p)
      end

      def render_validate_error
        render template: 'users/error', status: :bad_request
      end

      def render_create_error
        @resource = OpenStruct.new(errors: 'Internal server error')
        render template: 'users/error', status: :internal_server_error
      end

      def render_create_success
        render template: 'users/login'
      end

      def render_create_error_email_already_exists
        render template: 'users/error', status: :bad_request
      end
  end
end
