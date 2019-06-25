require 'rails_helper'

RSpec.describe GuestUserStrategy, type: :model do
  it 'inherits from LocalStrategy class' do
    expect(GuestUserStrategy).to be < LocalStrategy
  end

  describe '#process_checking_access' do
    let!(:user) { create(:user, role_name: :guest) }

    context 'with valid users attributes' do
      let!(:responsible_user) { create(:responsible_user) }

      it 'returns user with :guest role' do
        expect(subject.process_checking_access(responsible_user.as_json)).to eq user
      end
    end

    context 'with invalid users attributes' do
      it 'returns user with :guest role' do
        expect(subject.process_checking_access({ tn: 'test' }.as_json)).to eq user
      end
    end
  end
end
