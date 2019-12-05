require 'rails_helper'

RSpec.describe AuthCenterStrategy, type: :request do
  describe 'GET /api/v1/welcome' do
    let!(:user) { create(:user) }
    let(:access_token) { 'my_access_token' }
    let(:headers) { { Authorization: "Bearer #{access_token}" }.as_json }
    let(:auth_center_response) do
      {
        token_type: 'Bearer',
        expires_in: 123_456_789,
        access_token: access_token,
        refresh_token: 'my_refresh_token'
      }
    end
    before do
      stub_request(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info')
        .to_return(status: 200, body: user.to_json, headers: {})
    end

    it 'runs #access_token method for Api::V1::AuthCenterApi' do
      expect(Api::V1::AuthCenterApi).to receive(:user_info).with(access_token).and_call_original

      get '/api/v1/welcome.json', headers: headers
    end

    it 'runs #authenticate method for User' do
      expect(User).to receive(:authenticate).with(user.as_json).and_call_original

      get '/api/v1/welcome.json', headers: headers
    end

    it 'runs #success! method with User instance for AuthCenterStrategy instance' do
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
      before do
        stub_request(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info')
          .to_return(status: 401, body: { error: 'Not authorized' }.to_json, headers: {})
      end

      it 'returns with error message' do
        get '/api/v1/welcome.json', headers: headers

        expect(response.body).to be_json_eql({ error: 'Невалидный токен' }.to_json)
      end
    end
  end
end
