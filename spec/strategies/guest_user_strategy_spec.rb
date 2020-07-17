require 'rails_helper'

RSpec.describe GuestUserStrategy, type: :model do
  it 'inherits from LocalStrategy class' do
    expect(described_class).to be < LocalStrategy
  end

  describe '#process_searching_user' do
    let!(:user) { create(:user, role_name: :guest) }

    context 'with valid users attributes' do
      let!(:responsible_user) { create(:responsible_user) }

      it 'returns user with :guest role' do
        expect(subject.process_searching_user(responsible_user.as_json)).to eq user
      end
    end

    context 'with invalid users attributes' do
      it 'returns user with :guest role' do
        expect(subject.process_searching_user({ tn: 'test' }.as_json)).to eq user
      end
    end
  end
end
