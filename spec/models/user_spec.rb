require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to have_many(:visits).class_name('Ahoy::Visit').dependent(:nullify) }
  it { is_expected.to belong_to(:role) }
  it { is_expected.to validate_uniqueness_of(:tn).allow_nil }
  it { is_expected.to validate_uniqueness_of(:id_tn).allow_nil }

  describe '::authenticate' do
    let!(:user) { create(:guest_user) }
    let(:user_attrs) { { tn: 17_664 } }
    subject { User }

    it 'runs chain of strategies' do
      expect_any_instance_of(GuestUserStrategy).to receive(:search_user).and_return(user)

      subject.authenticate(user_attrs)
    end

    it 'returns user instance with associated role' do
      expect(subject.authenticate(user_attrs)).to eq user
    end

    it 'merges data from AuthCenter with finded user' do
      expect(subject.authenticate(user_attrs).tn).to eq user_attrs[:tn]
    end
  end
end
