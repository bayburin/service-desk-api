require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { is_expected.to have_many(:readers).class_name(NotificationReader).with_foreign_key(:notification_id).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:body) }
end
