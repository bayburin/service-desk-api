require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to have_many(:services).dependent(:destroy) }
  it { is_expected.to have_many(:tickets).through(:services) }
  it { is_expected.to validate_presence_of(:name) }
end
