require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:ticket_tags).dependent(:destroy) }
  it { is_expected.to have_many(:tags).through(:ticket_tags) }
  it { is_expected.to belong_to(:service) }
  it { is_expected.to validate_presence_of(:service_id) }
  it { is_expected.to validate_presence_of(:name) }
end
