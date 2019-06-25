require 'rails_helper'

RSpec.describe UserStrategy, type: :model do
  it 'inherits from LocalStrategy class' do
    expect(UserStrategy).to be < LocalStrategy
  end

  describe '#process_checking_access' do
    let!(:user) { create(:user) }

    context 'when user was found' do
      it 'returns founded user' do
        expect(subject.process_checking_access(user.as_json)).to eq user
      end
    end

    context 'when user was not found' do
      it 'returns nil' do
        expect(subject.process_checking_access({ tn: 'test' }.as_json)).to be_nil
      end
    end
  end
end
