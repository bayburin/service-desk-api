require 'rails_helper'

RSpec.describe UserStrategy, type: :model do
  it 'inherits from LocalStrategy class' do
    expect(UserStrategy).to be < LocalStrategy
  end

  describe '#process_searching_user' do
    let!(:user) { create(:user) }

    context 'when user was found' do
      it 'returns founded user' do
        expect(subject.process_searching_user(user.as_json)).to eq user
      end
    end

    context 'when user was not found' do
      it 'returns nil' do
        expect(subject.process_searching_user({ tn: 'test' }.as_json)).to be_nil
      end
    end

    context 'when tn is nil and in database exists guest user' do
      before do
        create(:guest_user, tn: nil, id_tn: nil)
        allow(user).to receive(:tn).and_return(nil)
      end

      it 'returns nil' do
        expect(subject.process_searching_user(user.as_json)).to be_nil
      end
    end
  end
end
