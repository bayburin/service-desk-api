require 'rails_helper'

module Api
  module V1
    RSpec.describe AuthController, type: :controller do
      sign_in_user

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
        let(:redis_key) { ReadCache.redis.get("token:#{token_response[:access_token]}") }
        let(:token_response_dbl) { double(:token_response, body: token_response.as_json, success?: true) }
        let(:user_info_response_dbl) { double(:token_response, body: user_info_response.as_json) }
        before do
          allow(AuthCenterApi).to receive(:access_token).and_return(token_response_dbl)
          allow(AuthCenterApi).to receive(:user_info).and_return(user_info_response_dbl)
        end

        it 'call #access_token method for Api::V1::AuthCenterApi class' do
          expect(AuthCenterApi).to receive(:access_token).with(params[:code])

          post :token, params: params, format: :json
        end

        it 'call #user_info method for Api::V1::AuthCenterApi with received access_token' do
          expect(AuthCenterApi).to receive(:user_info).with(token_response[:access_token])

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
          let(:status) { 500 }
          let(:token_response_dbl) { double(:token_response, status: status, success?: false) }

          it 'respond with status occured from authorization server' do
            post :token, params: params, format: :json

            expect(response.status).to eq status
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
