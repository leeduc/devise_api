module DeviseApi
  class PasswordsController < Devise::PasswordsController
    before_action :check_token, except: [:create, :edit]
    before_action :set_user, only: [:update]

    # POST /resource/password
    def create
      return render_create_error_missing_email unless resource_params[:email]
      # honor devise configuration for case_insensitive_keys
      if resource_class.case_insensitive_keys.include?(:email)
        @email = resource_params[:email].downcase
      else
        @email = resource_params[:email]
      end

      @resource = resource_class.where(email: @email).first
      return render_email_does_not_exits unless @resource

      yield if block_given?

      @resource.send_reset_password_instructions(email: @email)
      return render_send_failed unless successfully_sent?(@resource)
      render_reset_password_success
    end

    # GET /resource/password/edit?reset_password_token=abcdef
    def edit
      @resource = resource_class.reset_password_by_token(reset_password_token: resource_params[:reset_password_token])

      return render_reset_error unless @resource && @resource.id

      @resource.skip_confirmation! if @resource.devise_modules.include?(:confirmable) && !@resource.confirmed_at
      @resource.save!

      payload = {
        uid: SecureRandom.hex,
        exprire: DeviseApi.token_lifespan,
        reset_pass: true
      }

      @token = AuthHelper.generate_token @resource, payload

      render_reset_success
    end

    # PUT /resource/password
    def update
      fields = pass_params

      if defined? (@headerToken['reset_pass']) || @resource.valid_password?(fields[:current_password])
        return rendor_current_password_is_wrong
      end

      fields.delete(:current_password)

      return render_update_error unless @resource.update(fields)

      render_update_success
    end

    protected

      def set_user
        @resource = current_user
      end

      def render_create_error_missing_email
        @resource = OpenStruct.new(errors: { Email: ['cannot be blank.'] })
        render template: 'users/error', status: :bad_request
      end

      def render_reset_password_success
        render template: 'users/show'
      end

      def render_email_does_not_exits
        @resource = OpenStruct.new(errors: { Email: ['does not exists.'] })
        render template: 'users/error', status: :bad_request
      end

      def render_send_failed
        @resource = OpenStruct.new(errors: 'Send email reset password failed.')
        render template: 'users/error', status: :bad_request
      end

      def render_reset_error
        render template: 'users/error', status: :bad_request
      end

      def render_reset_success
        render template: 'users/login'
      end

      def render_update_error
        render template: 'users/error', status: :bad_request
      end

      def render_update_success
        render template: 'users/login'
      end

      def rendor_current_password_is_wrong
        @resource = OpenStruct.new(errors: { current_password: ['does not extraly.'] })
        render template: 'users/error', status: :bad_request
      end

      def resource_params
        params.permit(:email, :password, :password_confirmation, :current_password, :reset_password_token)
      end

      def pass_params
        params.permit(:current_password, :password, :password_confirmation)
      end
  end
end
