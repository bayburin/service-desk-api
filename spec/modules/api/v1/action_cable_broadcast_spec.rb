require 'rails_helper'

module Api
  module V1
    RSpec.describe ActionCableBroadcast do
      subject { Class.new.extend(ActionCableBroadcast) }
      let(:user) { create(:user) }

      describe '#broadcast_notification_to_user' do
        let(:message) { 'my custom message' }

        it 'broadcasts occured message to user' do
          expect { subject.broadcast_notification_to_user(user.tn, message) }
            .to have_broadcasted_to("notify/current_user_#{user.tn}").with(message)
        end
      end

      describe '#broadcast_notification_count' do
        let(:count) { 10 }

        it 'broadcasts occured count to user' do
          expect { subject.broadcast_notification_count(user.tn, count) }
            .to have_broadcasted_to("notification_count/current_user_#{user.tn}").with(count)
        end
      end
    end
  end
end
