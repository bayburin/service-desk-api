require 'rails_helper'

RSpec.describe Service, type: :model do
  it { is_expected.to have_many(:tickets).dependent(:destroy) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to validate_presence_of(:name) }
end
