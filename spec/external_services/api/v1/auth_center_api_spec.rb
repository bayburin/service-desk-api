require 'rails_helper'

module Api
  module V1
    RSpec.describe AuthCenterApi, type: :model do
      subject { AuthCenterApi }

      it 'define API_ENDPOINT constant' do
        expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
      end

      it 'included Api::V1::Connection module' do
        expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
      end

      describe '::access_token' do
        let(:auth_code) { 'fake_authorize_code' }
        let(:body) do
          {
            grant_type: 'authorization_code',
            client_id: ENV['AUTH_CENTER_APP_ID'],
            client_secret: ENV['AUTH_CENTER_APP_SECRET'],
            redirect_uri: ENV['AUTH_CENTER_APP_URL'],
            code: auth_code
          }
        end

        before { stub_request(:post, 'https://auth-center.iss-reshetnev.ru/oauth/token').to_return(status: 200, body: '', headers: {}) }

        it 'sends :post request with required params in body' do
          subject.access_token(auth_code)

          expect(WebMock).to have_requested(:post, 'https://auth-center.iss-reshetnev.ru/oauth/token').with(body: body.to_json)
        end

        it 'returns instance of Faraday::Response class' do
          expect(subject.access_token(auth_code)).to be_instance_of(Faraday::Response)
        end
      end

      describe '::user_info' do
        let(:access_token) { 'fake_access_token' }
        let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

        before { stub_request(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info').to_return(status: 200, body: '', headers: {}) }

        it 'sends :get request with required headers' do
          subject.user_info(access_token)

          expect(WebMock).to have_requested(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info').with(headers: headers)
        end

        it 'returns instance of Faraday::Response class' do
          expect(subject.user_info(access_token)).to be_instance_of(Faraday::Response)
        end
      end
    end
  end
end
