require 'rails_helper'

RSpec.describe Case, type: :model do
  case_attributes = %i[case_id service_id ticket_id user_tn id_tn user_info host_id item_id desc phone email mobile status_id status starttime endtime time rating]

  case_attributes.each do |attr|
    it { is_expected.to respond_to(attr) }
  end

  describe '#service' do
    context 'when service_id is defined' do
      let(:service) { create(:service) }
      subject { Case.new(service_id: service.id) }

      it 'returns instance of Service' do
        expect(subject.service).to eq Service.find(service.id)
      end
    end

    context 'when service_id is not defined' do
      subject { Case.new(service_id: nil) }

      it 'returns nil' do
        expect(subject.service).to be_nil
      end
    end
  end

  describe '#ticket' do
    context 'when ticket_id is defined' do
      let(:ticket) { create(:ticket) }
      subject { Case.new(ticket_id: ticket.id) }

      it 'returns instance of Ticket' do
        expect(subject.ticket).to eq Ticket.find(ticket.id)
      end
    end

    context 'when _id is not defined' do
      subject { Case.new(ticket_id: nil) }

      it 'returns nil' do
        expect(subject.ticket).to be_nil
      end
    end
  end

  describe '#attributes' do
    case_attributes.each do |attr|
      it "has :#{attr} attribute" do
        expect(subject.as_json.keys).to include(attr)
      end
    end
  end
end
