require 'rails_helper'

module Api
  module V1
    RSpec.describe AuthController, type: :controller do
      describe 'POST #token' do
        let(:user) { create(:user) }
        let(:params) { { code: 'authorization_code' } }
        let(:auth_center_response) do
          {
            token_type: 'Bearer',
            expires_in: 123_456_789,
            access_token: 'my_access_token',
            refresh_token: 'my_refresh_token'
          }
        end

        before do
          stub_request(:post, 'https://auth-center.iss-reshetnev.ru/oauth/token')
            .to_return(status: 200, body: auth_center_response.to_json, headers: {})
        end

        it 'runs #access_token method for Api::V1::AuthCenterApi class' do
          expect(Api::V1::AuthCenterApi).to receive(:access_token).with(params[:code]).and_call_original

          post :token, params: params, format: :json
        end

        it 'resond with data occured from authorization server' do
          post :token, params: params, format: :json

          expect(response.body).to eq auth_center_response.to_json
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
