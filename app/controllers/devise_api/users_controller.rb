module DeviseApi
  class UsersController < DeviseApi::ApplicationController
    before_action :check_token, except: [:show, :facebook_sign_up]
    before_action :set_user, only: [:show, :update, :change_password]

    def show
      render template: 'users/show'
    end

    # PATCH/PUT /users/:id.:format
    def update
      # authorize! :update, @resource
      @resource.assign_attributes(user_params)
      if @resource.save
        render template: 'users/show'
      else
        render template: 'users/error', status: :bad_request
      end
    end

    def facebook_sign_up
      begin
        @graph = Koala::Facebook::API.new(params[:token], DeviseApi.facebook_secret_key)
        profile = @graph.get_object('me', fields: %w(name email))
      rescue Koala::Facebook::AuthenticationError
        return render_custom_error('token', 'Token incorrect')
      rescue StandardError
        return render_custom_error('token', 'Session has expired')
      end

      name = profile['name'].split(' ')
      password = SecureRandom.hex(8)

      data = { email: profile['email'], facebook_id: profile['id'],
               first_name: name.shift, last_name: name.join(' '),
               password: password, password_confirmation: password }

      @resource = User.find_oauth(data)

      unless @resource.present?
        @resource = User.new(data)
        return render_create_error unless @resource.save
      end

      @token = AuthHelper.generate_token @resource
      save_token_device
      render_create_success
    end

    # DELETE /users/:id.:format
    def delete_token
      # authorize! :delete, @resource
      @resource = User.find(params[:id])
      @resource.destroy
      render template: 'users/show'
    end

    protected

      def render_create_success
        render template: 'users/login'
      end

      def render_create_error
        render template: 'users/error', status: :bad_request
      end

      def render_custom_error(key, ex)
        @resource = OpenStruct.new
        @resource.errors = { key => [ex.to_s.downcase] }

        render template: 'users/error', status: :bad_request
      end

    private

      def set_user
        @resource = User.find(params[:id])

        return render 'layouts/error', status: :forbidden, locals: {
          object: OpenStruct.new(message: 'Forbidden')
        } if action_name != 'show' && current_user.id != params[:id].to_i
      rescue
        @resource = OpenStruct.new(errors: 'User does not exists.')
        render template: 'users/error', status: :not_found
      end

      def user_params
        params.permit(:name, :first_name, :last_name)
      end

      def pass_params
        accessible = [:current_password, :password, :password_confirmation]
        params.permit(accessible)
      end

      def save_token_device
        return unless request.headers['DToken'].present?
        dtype = request.headers['DType'].present? ? request.headers['DType'] : 0
        DeviceToken.save_device_token request.headers['DToken'], @resource.id, dtype
      end
  end
end
