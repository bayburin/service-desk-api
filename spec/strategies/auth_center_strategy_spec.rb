require 'rails_helper'

RSpec.describe AuthCenterStrategy, type: :request do
  describe 'GET /api/v1/welcome' do
    let!(:user) { create(:user) }
    let(:access_token) { 'my_access_token' }
    let(:headers) { { Authorization: "Bearer #{access_token}" }.as_json }
    # let(:access_token) { 'my_token' }
    before { Api::V1::AuthCenter::AccessToken.set(access_token, user.as_json) }

    it 'call #authenticate method for User' do
      expect(User).to receive(:authenticate).with(user.as_json).and_call_original

      get '/api/v1/welcome.json', headers: headers
    end

    it 'call #success! method with User instance for AuthCenterStrategy instance' do
      expect_any_instance_of(AuthCenterStrategy).to receive(:success!).with(user)

      get '/api/v1/welcome.json', headers: headers
    end

    context 'when #authenticate method returns nil' do
      before { allow(User).to receive(:authenticate).and_return(nil) }

      it 'returns with error message' do
        get '/api/v1/welcome.json', headers: headers

        expect(response.body).to be_json_eql({ error: 'Не удается пройти авторизацию. Пользователь с соответствующей ролью не найден' }.to_json)
      end
    end

    context 'when authorization server respond with error' do
      before { allow(Api::V1::AuthCenter::AccessToken).to receive(:get).and_return(nil) }

      it 'respond with access denied message' do
        get '/api/v1/welcome.json', headers: headers

        expect(response.body).to be_json_eql({ error: 'Невалидный токен' }.to_json)
      end
    end
  end
end
