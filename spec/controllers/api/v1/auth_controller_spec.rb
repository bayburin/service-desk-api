require 'rails_helper'

module Api
  module V1
    RSpec.describe AuthController, type: :controller do
      describe 'POST #token' do
        let(:user) { create(:user) }
        let(:params) { { code: 'authorization_code' } }
        let(:token_response) do
          {
            token_type: 'Bearer',
            expires_in: 123_456_789,
            access_token: 'my_access_token',
            refresh_token: 'my_refresh_token'
          }
        end
        let(:user_info_response) { { 'tn' => '17664', 'dept' => '714', 'fio' => 'Байбурин Равиль Фаильевич' } }
        let(:redis_key) { ReadCache.redis.get("token:#{token_response['access_token']}") }
        before do
          stub_request(:post, 'https://auth-center.iss-reshetnev.ru/oauth/token')
            .to_return(status: 200, body: token_response.to_json, headers: {})
          stub_request(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info')
            .to_return(status: 200, body: user_info_response.to_json, headers: {})
        end

        it 'call #access_token method for Api::V1::AuthCenterApi class' do
          expect(Api::V1::AuthCenterApi).to receive(:access_token).with(params[:code]).and_call_original

          post :token, params: params, format: :json
        end

        it 'call #user_info method for Api::V1::AuthCenterApi with received access_token' do
          expect(Api::V1::AuthCenterApi).to receive(:user_info).with(token_response['access_token']).and_call_original

          post :token, params: params, format: :json
        end

        it 'save in redis database access_token and user information' do
          post :token, params: params, format: :json

          expect(redis_key).to eq user_info_response.to_json
        end

        it 'resond with data occured from authorization server' do
          post :token, params: params, format: :json

          expect(response.body).to eq token_response.to_json
        end

        it 'respond with status 200' do
          post :token, params: params, format: :json

          expect(response.status).to eq 200
        end

        context 'when authorization finished with error' do
          before do
            stub_request(:post, 'https://auth-center.iss-reshetnev.ru/oauth/token')
              .to_return(status: 401, body: { error: 'Not authorized' }.to_json, headers: {})
          end

          it 'respond with status occured from authorization server' do
            post :token, params: params, format: :json

            expect(response.status).to eq 401
          end

          it 'respond with error message' do
            post :token, params: params, format: :json

            expect(response.body).to be_json_eql('{"message":"Ошибка авторизации"}')
          end
        end
      end
    end
  end
end
