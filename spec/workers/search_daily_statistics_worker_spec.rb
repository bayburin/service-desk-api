require 'rails_helper'

RSpec.describe SearchDailyStatisticsWorker, type: :worker do
  let(:first_manager) { create(:content_manager_user, id_tn: 3, tn: 3) }
  let(:sec_manager) { create(:content_manager_user, id_tn: 4, tn: 4) }
  let(:managers) { [first_manager, sec_manager] }
  let(:events) { create_list(:search_event, 3) }
  before { allow_any_instance_of(Api::V1::EventsQuery).to receive(:all_search_by).and_return(events) }

  it 'call Api::V1::SendDailyStatistics worker for each manager' do
    managers.each do |manager|
      expect(SendDailyStatistics).to receive(:perform_async).with(manager.id, events.pluck(:properties), an_instance_of(Date))
    end

    subject.perform
  end
end
