require 'rails_helper'

module ApplicationCable
  RSpec.describe Connection, type: :channel do
    let(:user) { create(:user) }
    let(:access_token) { 'my_access_token' }

    context 'with valid access_token' do
      before { allow(Api::V1::AuthCenter::AccessToken).to receive(:get).and_return(user.as_json) }

      it 'successfully connects' do
        connect "/cable/?access_token=#{access_token}"

        expect(connection.current_user).to eq user
      end
    end

    context 'with invalid access_token' do
      before { allow(Api::V1::AuthCenter::AccessToken).to receive(:get).and_return(nil) }

      it 'rejects connection' do
        expect { connect "/cable/?access_token=#{access_token}" }.to have_rejected_connection
      end
    end
  end
end
