require 'rails_helper'

RSpec.describe SendDailyStatistics, type: :worker do
  let!(:manager) { create(:content_manager_user) }
  let(:search_list) { %w[search1 search2] }
  let(:sender) { double(Api::V1::ReportSender, send_report: true) }
  let(:date) { Date.today }
  before do
    allow(Api::V1::ReportSender).to receive(:new).and_return(sender)
    allow(User).to receive(:find).with(manager.id).and_return(manager)
    allow(manager).to receive(:load_details).and_return(manager)
  end

  it 'find user with specified id' do
    expect(User).to receive(:find).with(manager.id).and_return(manager)

    subject.perform(manager.id, search_list, date)
  end

  it 'call #load_details method for finded user' do
    expect(manager).to receive(:load_details)

    subject.perform(manager.id, search_list, date)
  end

  it 'create instance of ReportSender' do
    expect(Api::V1::ReportSender).to receive(:new).with(manager, search_list, date: date).and_return(sender)

    subject.perform(manager.id, search_list, date)
  end

  it 'call #send_report method for ReportSender instance' do
    expect(sender).to receive(:send_report).with(an_instance_of(Api::V1::Reporter::DailyStatisticsEmailSender))

    subject.perform(manager.id, search_list, date)
  end
end
