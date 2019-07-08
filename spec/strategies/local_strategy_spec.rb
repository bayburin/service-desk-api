require 'rails_helper'

RSpec.describe LocalStrategy, type: :model do
  describe '#search_user' do
    let!(:user) { create(:user) }
    let(:user_data) { { tn: user.tn }.as_json }

    context 'when user_data is valid' do
      before { allow(subject).to receive(:process_searching_user).and_return(user) }

      it 'returns finded user' do
        expect(subject.search_user(user_data)).to eq user
      end
    end

    context 'when user_data is invalid' do
      let(:user_data) { { tn: 'invalid_tn' }.as_json }
      before { allow(subject).to receive(:process_searching_user).and_return(nil) }

      it 'runs #failed_strategy method' do
        expect(subject).to receive(:failed_strategy)

        subject.search_user(user_data)
      end
    end

    context 'when user was not found on current strategy' do
      subject(:inheritance) { LocalStrategy.new }
      subject(:main) { LocalStrategy.new(inheritance) }
      before { allow(main).to receive(:process_searching_user).and_return(nil) }

      it 'runs next strategy' do
        expect(inheritance).to receive(:search_user).with(user_data).and_return(user)

        main.search_user(user_data)
      end
    end
  end

  describe '#process_searching_user' do
    it 'raise RuntimeError error' do
      expect { subject.process_searching_user('any data') }.to raise_error(RuntimeError, 'Not implemented')
    end
  end

  describe '#failed_strategy' do
    it 'raise RuntimeError error' do
      expect { subject.failed_strategy }.to raise_error(RuntimeError, 'Auth Strategy could not be invoked')
    end
  end
end
