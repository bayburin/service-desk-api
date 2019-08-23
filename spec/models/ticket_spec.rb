require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:ticket_tags).dependent(:destroy) }
  it { is_expected.to have_many(:tags).through(:ticket_tags) }
  it { is_expected.to have_many(:responsible_users).dependent(:destroy) }
  it { is_expected.to belong_to(:service) }
  it { is_expected.to validate_presence_of(:name) }

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
end
