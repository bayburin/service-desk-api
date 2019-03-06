require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { is_expected.to have_many(:ticket_tags).dependent(:destroy) }
  it { is_expected.to have_many(:tickets).through(:ticket_tags) }
end
