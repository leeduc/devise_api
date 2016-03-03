module DeviseApi
  class SessionsController < DeviseApi::ApplicationController
    before_action :check_token, except: [:create]

    def create
      begin
        fields = login_params
      rescue => ex
        return render_missing_params ex.param
      end

      @resource = resource_class.where(email: fields[:email]).first

      if @resource && @resource.valid_password?(fields[:password]) &&
         (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)

        @token = AuthHelper.generate_token @resource
        save_device_token
        render_create_success
      elsif @resource &&
            @resource.valid_password?(fields[:password]) &&
            !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        render_create_error_not_confirmed
      else
        render_create_error_bad_credentials
      end
    end

    def delete_token
      render nothing: true, status: :internal_server_error unless @detoken.destroy
      render nothing: true, status: :no_content
    end

    protected

      def save_device_token
        return unless request.headers['DToken'].present?
        dtype = request.headers['DType'].present? ? request.headers['DType'] : 0
        DeviceToken.save_device_token request.headers['DToken'], @resource.id, dtype
      end

      def render_create_error_not_confirmed
        @resource = OpenStruct.new(errors: 'User not active.')
        render template: 'users/error', status: :forbidden
      end

      def render_missing_params(ex)
        @resource = OpenStruct.new(errors: { ex => ['can not be blank.'] })
        render template: 'users/error', status: :bad_request
      end

      def render_create_error_bad_credentials
        @resource = OpenStruct.new(errors: 'Email or password is wrong.')
        render template: 'users/error', status: :bad_request
      end

      def render_create_success
        render template: 'users/login'
      end

      def login_params
        param! :email, String, required: true
        param! :password, String, required: true

        params.permit(:email, :password)
      end
  end
end
