require 'rails_helper'

module Doorkeeper
  RSpec.describe Auth, type: :model do
    let(:username) { 'test_user' }
    let(:password) { 'test_password'}
    let(:token) do
      {
        token_type: 'Bearer',
        access_token: 'jwt_fake_token',
        refresh_token: 'jwt_refresh_token'
      }
    end
    let(:user_data) do
      {
        id_tn: 12_880,
        tn: 17_664,
        fullname: 'Байбурин Равиль Фаильевич'
      }.as_json
    end
    let(:user_info) { UserInfo.new(nil, token[:access_token]) }
    subject { Auth.new(username, password) }
    before do
      stub_request(:post, 'https://auth-center.iss-reshetnev.ru/oauth/token')
        .to_return(body: token.to_json)
    end

    before do
      unless RSpec.current_example.metadata[:skip_before]
        allow(UserInfo).to receive(:new).and_return(user_info)
        allow(user_info).to receive(:run).and_return(true)
        allow(user_info).to receive(:data).and_return(user_data)
      end
    end

    its(:run) { is_expected.to be_truthy }

    it 'connects with auth_center' do
      subject.run

      expect(WebMock).to have_requested(:post, 'https://auth-center.iss-reshetnev.ru/oauth/token')
                           .with(body: {
                                   grant_type: 'password',
                                   username: username,
                                   password: password,
                                   client_id: 9,
                                   client_secret: 'xxeHbgcl3PHqdu83OT3TuE6WKWleDF6IhmbWgwxt',
                                   scope: 'test_api'
                                 })
    end

    it 'runs UserInfo service', :skip_before do
      expect_any_instance_of(UserInfo).to receive(:run).and_return(true)

      subject.run
    end

    it 'creates AuthCenterToken with resource_owner_id from user_data' do
      expect { subject.run }.to change(AuthCenterToken, :count).by(1)
      expect(AuthCenterToken.last.resource_owner_id).to eq user_data['id_tn']
    end
  end
end
