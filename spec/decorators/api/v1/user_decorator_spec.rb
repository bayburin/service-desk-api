require 'rails_helper'

module Api
  module V1
    RSpec.describe UserDecorator, type: :model do
      let(:user) { build(:user) }
      subject { UserDecorator.new(user) }

      it 'inherits from SimpleDelegator class' do
        expect(UserDecorator).to be < SimpleDelegator
      end

      describe '#read_notifications' do
        let!(:notifications) { create_list(:notification, 6, tn: user.tn) }
        let!(:readed_notification) { create(:notification, tn: user.tn) }
        let!(:reader) { create(:notification_reader, user: user, tn: user.tn, notification: readed_notification) }

        it 'creates readers for unreaded notifications' do
          subject.read_notifications

          notifications.each do |notification|
            expect(notification.readers.map(&:tn).uniq).to eq [user.tn]
          end
        end

        it 'returns unreaded notifications' do
          expect(subject.read_notifications).to contain_exactly(*notifications)
        end
      end
    end
  end
end
