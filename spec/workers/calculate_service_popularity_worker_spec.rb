require 'rails_helper'

RSpec.describe CalculateServicePopularityWorker, type: :worker do
  let(:service) { create(:service) }
  let!(:old_popularity) { service.popularity }
  let(:changes_popularity) { service.calculate_popularity - old_popularity }
  let!(:tickets) { create_list(:ticket, 3, service: service) }

  before { allow(Service).to receive(:find).and_return(service) }

  it 'finds service with specified id' do
    expect(Service).to receive(:find).with(service.id)

    subject.perform(service.id)
  end

  it 'runs :calculate_popularity method' do
    expect(service).to receive(:calculate_popularity)

    subject.perform(service.id)
  end

  it 'updates popularity' do
    expect { subject.perform(service.id) }.to change(service, :popularity).by(changes_popularity)
  end
end
