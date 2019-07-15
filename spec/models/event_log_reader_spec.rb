require 'rails_helper'

RSpec.describe NotificationReader, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:notification) }
end
