require 'rails_helper'

RSpec.describe TicketTag, type: :model do
  it { is_expected.to belong_to(:ticket) }
  it { is_expected.to belong_to(:tag) }
end
