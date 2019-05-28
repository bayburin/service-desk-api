require 'rails_helper'

RSpec.describe Service, type: :model do
  it { is_expected.to have_many(:tickets).dependent(:destroy) }
  it { is_expected.to have_many(:responsible_users).dependent(:destroy) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to validate_presence_of(:name) }

  it 'includes Associatable module' do
    expect(subject.singleton_class.ancestors).to include(Associatable)
  end

  describe '#calculate_popularity' do
    let(:service) { create(:service) }

    it 'calculate popularity based on nested services' do
      expect(service.calculate_popularity).to eq service.tickets.pluck(:popularity).reduce(:+)
    end
  end
end
