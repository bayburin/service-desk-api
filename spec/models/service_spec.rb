  require 'rails_helper'

RSpec.describe Service, type: :model do
  it { is_expected.to have_many(:tickets).dependent(:destroy) }
  it { is_expected.to have_many(:question_tickets).through(:tickets).source(:ticketable) }
  it { is_expected.to have_many(:responsible_users).dependent(:destroy) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to validate_presence_of(:name) }

  it 'includes Associatable module' do
    expect(subject.singleton_class.ancestors).to include(Associatable)
  end

  it 'includes Belongable module' do
    expect(subject.singleton_class.ancestors).to include(Belongable)
  end

  describe '#calculate_popularity' do
    let(:service) { create(:service) }

    it 'calculate popularity based on nested services' do
      expect(service.calculate_popularity).to eq service.tickets.pluck(:popularity).reduce(:+)
    end
  end

  describe '#belongs_by_tickets_to?' do
    subject { create(:service) }
    let(:ticket) { create(:ticket, service: subject) }
    let(:user) { create(:user) }

    context 'when ticket belongs to user' do
      before { user.tickets << ticket }

      it 'returns true' do
        expect(subject.belongs_by_tickets_to?(user)).to be_truthy
      end
    end

    it 'returns false' do
      expect(subject.belongs_by_tickets_to?(user)).to be_falsey
    end
  end
end
