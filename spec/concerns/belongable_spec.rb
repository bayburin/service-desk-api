require 'rails_helper'

RSpec.describe Belongable, type: :model do
  subject { create(:service) }

  describe '#belongs_to?' do
    let(:user) { create(:user) }

    context 'when record belongs to user' do
      before { user.services << subject }

      it 'returns true' do
        expect(subject.belongs_to?(user)).to be_truthy
      end
    end

    it 'returns false' do
      expect(subject.belongs_to?(user)).to be_falsey
    end
  end
end
