require 'rails_helper'

module ApplicationCable
  RSpec.describe Connection, type: :channel do
    let(:user) { create(:user) }
    let(:access_token) { 'my_access_token' }

    context 'with valid access_token' do
      before do
        stub_request(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info')
          .to_return(status: 200, body: user.to_json, headers: {})
      end

      it 'successfully connects' do
        connect "/cable/?access_token=#{access_token}"

        expect(connection.current_user).to eq user
      end
    end

    context 'with invalid access_token' do
      before do
        stub_request(:get, 'https://auth-center.iss-reshetnev.ru/api/module/main/login_info')
          .to_return(status: 401, body: { error: 'Invalid token' }.to_json, headers: {})
      end

      it 'rejects connection' do
        expect { connect "/cable/?access_token=#{access_token}" }.to have_rejected_connection
      end
    end
  end
end
