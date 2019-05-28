require 'rails_helper'

RSpec.describe CalculatePopularityWorker, type: :worker do
  before { create_list(:service, 5) }

  it 'runs CalculateServicePopularityWorker worker for each service with :id param' do
    expect(CalculateServicePopularityWorker).to receive(:perform_async).with(kind_of(Numeric)).exactly(5).times

    subject.perform
  end

  it 'runs CalculateCategoryPopularityWorker worker for each category with :id param' do
    expect(CalculateCategoryPopularityWorker).to receive(:perform_async).with(kind_of(Numeric)).exactly(5).times

    subject.perform
  end
end
