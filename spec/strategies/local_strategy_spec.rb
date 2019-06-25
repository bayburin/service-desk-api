require 'rails_helper'

RSpec.describe LocalStrategy, type: :model do
  describe '#check_access' do
    let!(:user) { create(:user) }
    let(:user_data) { { tn: user.tn }.as_json }

    context 'when user_data is valid' do
      before { allow(subject).to receive(:process_checking_access).and_return(user) }

      it 'returns finded user' do
        expect(subject.check_access(user_data)).to eq user
      end
    end

    context 'when user_data is invalid' do
      let(:user_data) { { tn: 'invalid_tn' }.as_json }
      before { allow(subject).to receive(:process_checking_access).and_return(nil) }

      it 'runs #failed_strategy method' do
        expect(subject).to receive(:failed_strategy)

        subject.check_access(user_data)
      end
    end

    context 'when user was not found on current strategy' do
      subject(:inheritance) { LocalStrategy.new }
      subject(:main) { LocalStrategy.new(inheritance) }
      before { allow(main).to receive(:process_checking_access).and_return(nil) }

      it 'runs next strategy' do
        expect(inheritance).to receive(:check_access).with(user_data).and_return(user)

        main.check_access(user_data)
      end
    end
  end

  describe '#process_checking_access' do
    it 'raise RuntimeError error' do
      expect { subject.process_checking_access('any data') }.to raise_error(RuntimeError, 'Not implemented')
    end
  end

  describe '#failed_strategy' do
    it 'raise RuntimeError error' do
      expect { subject.failed_strategy }.to raise_error(RuntimeError, 'Auth Strategy could not be invoked')
    end
  end
end
