require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to have_many(:visits).class_name('Ahoy::Visit').dependent(:nullify) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to validate_uniqueness_of(:tn).allow_nil }
  it { is_expected.to validate_uniqueness_of(:id_tn).allow_nil }
end
