describe DeviseApi::SessionsController, type: :controller do
  include Devise::TestHelpers
  include Requests::JsonHelpers
  routes { DeviseApi::Engine.routes }
  describe 'POST #create' do
    it 'fails, empty email input' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, format: :json
      expect(response).to have_http_status(400)
      body = json(response.body)
      expect(body['status']).to eq('error')
      expect(body['errors']['email'][0]).to eq('can not be blank.')
    end

    it 'fails, empty email input' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, email: 'abc@example.com', format: :json
      expect(response).to have_http_status(400)
      body = json(response.body)
      expect(body['status']).to eq('error')
      expect(body['errors']['password'][0]).to eq('can not be blank.')
    end

    it 'fail, user not active' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      post :create, email: user.email, password: 123_456, format: :json
      expect(response).to have_http_status(403)
      body = json(response.body)
      expect(body['status']).to eq('error')
      expect(body['errors']).to eq('User not active.')
    end

    it 'success' do
      user = FactoryGirl.create(:user)
      user.confirm

      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, email: user.email, password: 123_456, format: :json

      expect(response).to have_http_status(200)
      body = json(response.body)
      expect(body['status']).to eq('success')
      content = body['entities'][0]
      expect(content['id']).to eq(user.id)
      expect(content['email']).to eq(user.email)
      expect(content['first_name']).to eq(user.first_name)
      expect(content['last_name']).to eq(user.last_name)
      expect(content['token']).not_to be_empty
    end
  end
end
#
