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

  describe '#new_notifications' do
    let!(:event_logs) { create_list(:event_log, 3, tn: subject.tn) }
    let!(:readed_event) { create(:event_log, tn: subject.tn) }
    let!(:reader) { create(:event_log_reader, user: subject, tn: subject.tn, event_log: readed_event) }

    it 'returns all EventLog records witch does not have associated EventLogReader records' do
      expect(subject.new_notifications).to eq event_logs
    end
  end
end
