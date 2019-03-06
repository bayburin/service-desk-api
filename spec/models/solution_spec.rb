require 'rails_helper'

RSpec.describe Solution, type: :model do
  it { is_expected.to belong_to(:ticket) }
  it { is_expected.to validate_presence_of(:ticket_id) }
  it { is_expected.to validate_presence_of(:solution) }
end
