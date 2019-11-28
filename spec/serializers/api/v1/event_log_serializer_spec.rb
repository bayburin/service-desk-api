require 'rails_helper'

module Api
  module V1
    RSpec.describe NotificationSerializer, type: :model do
      let(:user) { build(:user) }
      let(:notification) { create(:notification, tn: user.tn) }
      subject { NotificationSerializer.new(notification).to_json }

      %w[id event_type tn body date].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
