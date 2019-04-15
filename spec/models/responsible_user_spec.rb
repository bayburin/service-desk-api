require 'rails_helper'

RSpec.describe ResponsibleUser, type: :model do
  it { is_expected.to belong_to(:responseable) }
end
