require 'rails_helper'

RSpec.describe NotificationReader, type: :model do
  let(:user) { build(:user) }
  subject { build(:notification_reader, user: user, tn: user.tn) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:notification) }
  it { is_expected.to validate_uniqueness_of(:tn).scoped_to(:notification_id) }
  it { is_expected.to validate_presence_of(:tn) }
end
