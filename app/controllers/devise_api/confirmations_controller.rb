module DeviseApi
  class ConfirmationsController < Devise::ConfirmationsController
    before_action :check_token, except: [:show]

    def show
      @resource = resource_class.confirm_by_token(params[:confirmation_token])

      fail ActionController::RoutingError, 'Not Found' unless @resource && @resource.id

      @token = AuthHelper.generate_token @resource

      render_create_success
    end

    protected

      def render_create_success
        render template: 'users/confirmation.html'
      end
  end
end
