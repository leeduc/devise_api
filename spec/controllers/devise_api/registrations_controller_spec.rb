describe DeviseApi::RegistrationsController, type: :controller do
  include Requests::JsonHelpers
  routes { DeviseApi::Engine.routes }
  describe 'POST /user/sign_in' do
    it 'fail, empty field' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, format: :json
      expect(response).to have_http_status(400)
      body = json(response.body)
      expect(body['status']).to eq('error')
      expect(body['errors']['email']).to eq(['can\'t be blank', 'wrong email address'])
      expect(body['errors']['first_name']).to eq(['can\'t be blank'])
      expect(body['errors']['last_name']).to eq(['can\'t be blank'])
      expect(body['errors']['password']).to eq(['can\'t be blank', 'is too short (minimum is 6 characters)'])
    end

    it 'fail, empty field' do
      user = FactoryGirl.create(:user)
      user.confirm

      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create, email: user.email,
                    password: 123_123_123,
                    password_confirmation: 123_123_123,
                    first_name: 'David',
                    last_name: 'Beckham',
                    format: :json
      expect(response).to have_http_status(400)
      body = json(response.body)
      expect(body['status']).to eq('error')
      expect(body['errors']['email']).to eq(['already exists'])
    end

    it 'fail, empty field' do
      @request.env['devise.mapping'] = Devise.mappings[:user]

      fill_data = {
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }

      data = fill_data
      post :create, email: data[:email],
                    password: 123_123_123,
                    password_confirmation: 123_123_123,
                    first_name: data[:first_name],
                    last_name: data[:last_name],
                    format: :json

      expect(response).to have_http_status(200)
      body = json(response.body)
      expect(body['status']).to eq('success')
      expect(body['entities'][0]['email']).to eq(data[:email])
      expect(body['entities'][0]['first_name']).to eq(data[:first_name])
      expect(body['entities'][0]['last_name']).to eq(data[:last_name])
    end
  end
end
