require 'rails_helper'

RSpec.describe ServiceSerializer, type: :model do
  let(:service) { create(:service) }
  let!(:ticket) { create(:ticket, service: service) }

  subject { ServiceSerializer.new(service) }

  %w[id category_id name short_description install popularity is_hidden has_common_case popularity category tickets].each do |attr|
    it "has #{attr} attribute" do
      expect(subject.to_json).to have_json_path(attr)
    end
  end

  describe '#include_tickets?' do
    context 'when :without_associations attribute setted to true' do
      let(:service) { create(:service, without_associations: true) }

      it 'returns false' do
        expect(subject).to receive(:include_tickets?).and_return(false)

        subject.to_json
      end
    end

    context 'when :without_associations attribute setted to false' do
      let(:service) { create(:service, without_associations: false) }

      it 'returns false' do
        expect(subject).to receive(:include_tickets?).and_return(true)

        subject.to_json
      end
    end
  end

  describe '#include_category?' do
    context 'when :without_associations attribute setted to true' do
      let(:service) { create(:service, without_associations: true) }

      it 'returns false' do
        expect(subject).to receive(:include_tickets?).and_return(false)

        subject.to_json
      end
    end

    context 'when :without_associations attribute setted to false' do
      let(:service) { create(:service, without_associations: false) }

      it 'returns false' do
        expect(subject).to receive(:include_tickets?).and_return(true)

        subject.to_json
      end
    end
  end

  describe '#tickets' do
    it 'create instance of Api::V1::TicketsQuery' do
      expect(Api::V1::TicketsQuery).to receive(:new).with(service.tickets).and_call_original

      subject.to_json
    end

    it 'runs :visible method' do
      expect_any_instance_of(Api::V1::TicketsQuery).to receive_message_chain(:visible, :includes)

      subject.to_json
    end

    context 'when ticket has :without_associations attribute' do
      let!(:ticket) { create(:ticket, service: service) }
      let(:service) { create(:service) }

      before { service.tickets.each(&:without_associations!) }

      it 'runs :includes method' do
        expect_any_instance_of(Api::V1::TicketsQuery).to receive(:visible).and_call_original

        subject.to_json
      end
    end
  end
end
