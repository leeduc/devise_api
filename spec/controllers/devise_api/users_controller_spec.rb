describe DeviseApi::UsersController, type: :controller do
  include Devise::TestHelpers
  include UserHelpers
  include Requests::JsonHelpers
  routes { DeviseApi::Engine.routes }

  describe 'GET /user/:id' do
    it 'fail, does not exist' do
      get :show, id: Faker::Number.number(5), format: :json
      expect(response).to have_http_status(404)
    end

    it 'success, exists' do
      user = FactoryGirl.create(:user)
      get :show, id: user.id.to_s, format: :json

      expect(response).to have_http_status(200)
      body = json(response.body)
      expect(body['status']).to eq('success')
      expect(body['entities'][0]['id']).to eq(user.id)
      expect(body['entities'][0]['email']).to eq(user.email)
      expect(body['entities'][0]['first_name']).to eq(user.first_name)
      expect(body['entities'][0]['last_name']).to eq(user.last_name)
    end
  end

  describe 'PUT /user/:id' do
    it 'fail, does not exists' do
      user = _login
      request.headers['Access-Token'] = user.token

      put :update,
          id: Faker::Number.number(5),
          format: :json

      expect(response).to have_http_status(404)
    end

    it 'fail, token be blank' do
      user = FactoryGirl.create(:user)
      put :update, id: user.id, format: :json
      expect(response).to have_http_status(403)
    end

    it 'fail, wrong user id' do
      user = FactoryGirl.create(:user)
      user.confirm

      body = _login
      request.headers['Access-Token'] = body.token

      put :update,
          id: user.id.to_s,
          format: :json

      expect(response).to have_http_status(403)
    end

    it 'success, change', focus: true do
      user = _login

      set_d = {
        first_name: Faker::Name.name,
        last_name: Faker::Name.name
      }
      data = set_d
      request.headers['Access-Token'] = user.token
      allow(controller).to receive(:user_params).and_return data

      put :update, id: user.id, format: :json

      expect(response).to have_http_status(200)
      body = json(response.body)
      expect(body['status']).to eq('success')
      expect(body['entities'][0]['id']).to eq(user.id)
      expect(body['entities'][0]['email']).to eq(user.email)
      expect(body['entities'][0]['first_name']).to eq(data[:first_name])
      expect(body['entities'][0]['last_name']).to eq(data[:last_name])
    end
  end
end
#
