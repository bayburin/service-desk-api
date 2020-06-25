require 'rails_helper'

RSpec.describe App, type: :model do
  app_attributes = %i[case_id service_id ticket_id user_tn id_tn user_info host_id item_id desc phone email mobile status_id status starttime endtime time rating]

  app_attributes.each do |attr|
    it { is_expected.to respond_to(attr) }
  end

  describe '#service' do
    context 'when service_id is defined' do
      let(:service) { create(:service) }
      subject { App.new(service_id: service.id) }

      it 'returns instance of Service' do
        expect(subject.service).to eq Service.find(service.id)
      end
    end

    context 'when service_id is not defined' do
      subject { App.new(service_id: nil) }

      it 'returns nil' do
        expect(subject.service).to be_nil
      end
    end
  end

  describe '#runtime=' do
    let!(:current_time) { Time.zone.now }
    let!(:starttime) { current_time - 10.days }
    let!(:endtime) { current_time + 10.days }
    let!(:time) { current_time.change(usec: 0) }
    let!(:runtime) { Api::V1::Runtime.new(starttime: starttime, endtime: endtime, time: time.to_i) }

    before { subject.runtime = runtime }

    %i[starttime endtime time].each do |attr|
      it "changes :#{attr} attribute" do
        expect(subject.send(attr)).to eq send(attr)
      end
    end
  end

  describe '#ticket' do
    context 'when ticket_id is defined' do
      let(:ticket) { create(:ticket) }
      subject { App.new(ticket_id: ticket.id) }

      it 'returns instance of Ticket' do
        expect(subject.ticket).to eq Ticket.find(ticket.id)
      end
    end

    context 'when _id is not defined' do
      subject { App.new(ticket_id: nil) }

      it 'returns nil' do
        expect(subject.ticket).to be_nil
      end
    end
  end

  describe '#attributes' do
    app_attributes.each do |attr|
      it "has :#{attr} attribute" do
        expect(subject.as_json.keys).to include(attr)
      end
    end
  end
end
