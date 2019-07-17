require 'rails_helper'

module Api
  module V1
    RSpec.describe NotificationsQuery, type: :model do
      let(:user) { build(:user) }
      let!(:user_notifications) { create_list(:notification, 5, tn: user.tn) }
      let!(:broadcast_notifications) { create_list(:notification, 3, event_type: :broadcast) }
      let!(:other) { create_list(:notification, 5) }
      let(:notification_count) { (user_notifications + broadcast_notifications).count }
      subject { NotificationsQuery.new(user) }

      it 'inherits from ApplicationQuery class' do
        expect(CategoriesQuery).to be < ApplicationQuery
      end

      context 'when scope does not exist' do
        it 'creates scope' do
          expect(subject.scope).to eq Notification.all
        end
      end

      context 'when scope exists' do
        let(:scope) { Notification.first(2) }
        subject { CategoriesQuery.new(scope) }

        it 'use current scope' do
          expect(subject.scope).to eq scope
        end
      end

      describe '#all' do
        it 'returns all notifications for user' do
          expect(subject.all.count).to eq notification_count
        end

        it 'orders notifications' do
          expect(subject.unread.pluck(:id)).to eq broadcast_notifications.pluck(:id).reverse + user_notifications.pluck(:id).reverse
        end
      end

      describe '#unread' do
        let!(:reader) { create(:notification_reader, user: user, tn: user.tn, notification: user_notifications.first) }

        it 'returns all Notification records witch does not have associated NotificationReader records' do
          expect(subject.unread.count).to eq notification_count - 1
        end

        it 'orders notifications' do
          expect(subject.unread.pluck(:id)).to eq broadcast_notifications.pluck(:id).reverse + user_notifications.pluck(:id).drop(1).reverse
        end

        it 'does not have any associated readers' do
          subject.unread.each do |event|
            expect(event.readers).to be_empty
          end
        end
      end

      describe '#last_notifications' do
        it 'returns all notification limited by specified value' do
          expect(subject.last_notifications(3).count).to eq 3
        end

        it 'orders notifications' do
          expect(subject.last_notifications(3).pluck(:id)).to eq broadcast_notifications.pluck(:id).reverse
        end
      end
    end
  end
end
