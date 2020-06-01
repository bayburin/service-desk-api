require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to have_many(:services).dependent(:destroy) }
  it { is_expected.to have_many(:questions).through(:services) }
  it { is_expected.to validate_presence_of(:name) }

  it 'includes Associatable module' do
    expect(subject.singleton_class.ancestors).to include(Associatable)
  end

  describe '#calculate_popularity' do
    let!(:category) { create(:category) }

    it 'calculate popularity based on nested services' do
      expect(category.calculate_popularity).to eq category.services.pluck(:popularity).reduce(:+)
    end
  end
end
