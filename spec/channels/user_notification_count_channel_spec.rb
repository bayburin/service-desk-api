require 'rails_helper'

RSpec.describe UserNotificationCountChannel, type: :channel do
  let(:user) { create(:user) }
  before { stub_connection current_user: user }

  it 'subscribes to channel' do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("notification_count/current_user_#{user.tn}")
  end

  describe '#get' do
    let!(:notification) { create(:notification, tn: user.tn) }

    it 'transmit count of unreaded messages' do
      subscribe

      perform :get
      expect(transmissions.last).to eq 1
    end
  end
end
