require 'rails_helper'

RSpec.describe CalculateCategoryPopularityWorker, type: :worker do
  let(:category) { create(:category) }
  let!(:old_popularity) { category.popularity }
  let(:changes_popularity) { category.calculate_popularity - old_popularity }
  let!(:services) { create_list(:service, 3, category: category) }

  before { allow(Category).to receive(:find).and_return(category) }

  it 'finds service with specified id' do
    expect(Category).to receive(:find).with(category.id)

    subject.perform(category.id)
  end

  it 'runs :calculate_popularity method' do
    expect(category).to receive(:calculate_popularity)

    subject.perform(category.id)
  end

  it 'updates popularity' do
    expect { subject.perform(category.id) }.to change(category, :popularity).by(changes_popularity)
  end
end
