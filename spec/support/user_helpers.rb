module UserHelpers
  def _login(email = nil)
    include DeviseApi::AuthHelper
    user = FactoryGirl.create(:user)
    user.confirm

    email ||= user.email

    @resource = DeviseApi::User.where(email: email).first
    @resource.token = DeviseApi::AuthHelper.generate_token @resource
    @resource
  end
end
