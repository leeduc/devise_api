module ActionDispatch::Routing
  class Mapper
    def mount_devise_api_for(resource, opts)
      # ensure objects exist to simplify attr checks
      opts[:controllers] ||= {}
      opts[:skip] ||= []

      # check for ctrl overrides, fall back to defaults
      sessions_ctrl          = opts[:controllers][:sessions] || 'devise_api/sessions'
      registrations_ctrl     = opts[:controllers][:registrations] || 'devise_api/registrations'
      passwords_ctrl         = opts[:controllers][:passwords] || 'devise_api/passwords'
      confirmations_ctrl     = opts[:controllers][:confirmations] || 'devise_api/confirmations'
      token_validations_ctrl = opts[:controllers][:token_validations] || 'devise_api/token_validations'
      omniauth_ctrl          = opts[:controllers][:omniauth_callbacks] || 'devise_api/omniauth_callbacks'
      user_ctrl              = opts[:controllers][:user_ctrl] || 'devise_api/users'

      # define devise controller mappings
      controllers = { sessions: sessions_ctrl,
                      registrations: registrations_ctrl,
                      passwords: passwords_ctrl,
                      confirmations: confirmations_ctrl }

      # remove any unwanted devise modules
      opts[:skip].each { |item| controllers.delete(item) }

      devise_for resource.pluralize.underscore.tr('/', '_').to_sym,
                 class_name: resource,
                 module: :devise,
                 path: "#{opts[:at]}",
                 controllers: controllers,
                 skip: opts[:skip] + [:omniauth_callbacks]

      unnest_namespace do
        # get full url path as if it were namespaced
        full_path = "#{@scope[:path]}/#{opts[:at]}"

        # get namespace name
        namespace_name = @scope[:as]

        # clear scope so controller routes aren't namespaced
        @scope = ActionDispatch::Routing::Mapper::Scope.new(
          path:         '',
          shallow_path: '',
          constraints:  {},
          defaults:     {},
          options:      {},
          parent:       nil
        )

        mapping_name = resource.underscore.tr('/', '_')
        mapping_name = "#{namespace_name}_#{mapping_name}" if namespace_name

        devise_scope mapping_name.to_sym do
          # path to verify token validity
          get "#{full_path}/validate_token", controller: "#{token_validations_ctrl}", action: 'validate_token'
          put "#{opts[:at]}/:id/password", controller: passwords_ctrl, action: 'update'
          post "#{opts[:at]}/sign_out", controller: sessions_ctrl, action: 'delete_token'
          post "#{opts[:at]}/facebook_sign_up", controller: user_ctrl, action: 'facebook_sign_up'
          if user_ctrl.split('/').length > 1
            resources user_ctrl.split('/').last, module: user_ctrl.split('/').first,
                                                 path: opts[:at],
                                                 only: [:show, :update, :destroy]
          else
            resources user_ctrl, path: opts[:at], only: [:show, :update, :destroy]
          end
          # omniauth routes. only define if omniauth is installed and not skipped.
          if defined?(::OmniAuth) && !opts[:skip].include?(:omniauth_callbacks)
            match "#{full_path}/failure",            controller: omniauth_ctrl, action: 'omniauth_failure', via: [:get]
            match "#{full_path}/:provider/callback", controller: omniauth_ctrl, action: 'omniauth_success', via: [:get]

            match "#{DeviseApi.omniauth_prefix}/:provider/callback", controller: omniauth_ctrl,
                                                                     action: 'redirect_callbacks', via: [:get, :post]
            match "#{DeviseApi.omniauth_prefix}/failure", controller: omniauth_ctrl,
                                                          action: 'omniauth_failure',
                                                          via: [:get, :post]

            # preserve the resource class thru oauth authentication by setting name of
            # resource as "resource_class" param
            match "#{full_path}/:provider", to: redirect { |params, request|
              # get the current querystring
              qs = CGI::parse(request.env['QUERY_STRING'])

              # append name of current resource
              qs['resource_class'] = [resource]

              set_omniauth_path_prefix!(DeviseApi.omniauth_prefix)

              # re-construct the path for omniauth
              "#{::OmniAuth.config.path_prefix}/#{params[:provider]}?#{{}.tap {|hash| qs.each{|k, v| hash[k] = v.first}}.to_param}"
            }, via: [:get]
          end
        end
      end
    end

    # this allows us to use namespaced paths without namespacing the routes
    def unnest_namespace
      current_scope = @scope.dup
      yield
    ensure
      @scope = current_scope
    end

    # ignore error about omniauth/multiple model support
    def set_omniauth_path_prefix!(path_prefix)
      ::OmniAuth.config.path_prefix = path_prefix
    end
  end
end
