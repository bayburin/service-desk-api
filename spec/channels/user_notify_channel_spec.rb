require 'rails_helper'

RSpec.describe UserNotifyChannel, type: :channel do
  let(:user) { create(:user) }
  before { stub_connection current_user: user }

  it 'subscribes to channel' do
    subscribe

    expect(subscription).to be_confirmed
    expect(streams).to include("notify/current_user_#{user.tn}")
  end
end
