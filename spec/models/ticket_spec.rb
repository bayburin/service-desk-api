require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { is_expected.to have_many(:ticket_tags).dependent(:destroy) }
  it { is_expected.to have_many(:tags).through(:ticket_tags) }
  it { is_expected.to have_many(:responsible_users).dependent(:destroy) }
  it { is_expected.to belong_to(:service) }

  it 'includes Associatable module' do
    expect(subject.singleton_class.ancestors).to include(Associatable)
  end

  it 'includes Belongable module' do
    expect(subject.singleton_class.ancestors).to include(Belongable)
  end

  describe '#calculate_popularity' do
    let!(:popularity) { subject.popularity + 1 }

    it 'increases popularity' do
      expect(subject.calculate_popularity).to eq popularity
    end
  end

  describe '#responsibles' do
    subject { create(:ticket) }
    let!(:responsible_users) { create(:responsible_user, responseable: subject) }

    it 'returns responsible_users' do
      expect(subject.responsibles).to eq [responsible_users]
    end

    context 'when responsible_users is empty' do
      let!(:responsible_users) { create(:responsible_user, responseable: subject.service) }
      before { subject.responsible_users.destroy_all }

      it 'returns responsible_users of parent service' do
        expect(subject.responsibles).to eq [responsible_users]
      end
    end
  end

  describe '.generate_identity' do
    let(:expected_identity) { Ticket.maximum(:identity).to_i + 1 }

    it 'set new identity' do
      expect(described_class.generate_identity).to eq expected_identity
    end
  end

  describe '#generate_identity' do
    let(:identity) { 123 }
    before { allow(described_class).to receive(:generate_identity).and_return(identity) }

    it 'call Ticket.generate_identity' do
      expect(subject.generate_identity).to eq identity
    end
  end
end
