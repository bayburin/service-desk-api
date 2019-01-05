require 'rails_helper'

module Doorkeeper
  RSpec.describe UserInfo, type: :model do
    let!(:auth_center_token) { create(:auth_center_token) }
    let!(:doorkeeper_token) { create(:doorkeeper_token) }
    let(:user_data) do
      {
        id_tn: 12_880,
        tn: 17_664,
        fullname: 'Байбурин Равиль Фаильевич'
      }.as_json
    end

    before do
      stub_request(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info')
        .to_return(body: user_data.to_json)
    end

    context 'with auth_center_token' do
      subject { UserInfo.new(nil, auth_center_token.access_token) }

      it 'connects with auth_center' do
        subject.run

        expect(WebMock).to have_requested(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info')
                             .with(headers: {
                                     'Content-Type': 'application/json',
                                     'Authorization': "Bearer #{auth_center_token.access_token}"
                                   })
      end

      its(:run) { is_expected.to be_truthy }
    end

    context 'with doorkeeper_token' do
      subject { UserInfo.new(doorkeeper_token) }

      it 'connects with auth_center' do
        subject.run

        expect(WebMock).to have_requested(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info')
                             .with(headers: {
                                     'Content-Type': 'application/json',
                                     'Authorization': "Bearer #{auth_center_token.access_token}"
                                   })
      end

      its(:run) { is_expected.to be_truthy }
    end
  end
end
