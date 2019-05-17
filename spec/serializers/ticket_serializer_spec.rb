require 'rails_helper'

RSpec.describe TicketSerializer, type: :model do
  let(:ticket) { create(:ticket) }
  subject { TicketSerializer.new(ticket) }

  %w[id service_id name ticket_type is_hidden sla popularity answers tags service].each do |attr|
    it "has #{attr} attribute" do
      expect(subject.to_json).to have_json_path(attr)
    end
  end

  describe '#include_associations?' do
    context 'when :without_associations attribute setted to true' do
      let(:ticket) { create(:ticket, without_associations: true) }

      it 'returns false' do
        expect(subject).to receive(:include_associations?).at_least(1).and_return(false)

        subject.to_json
      end

      %w[answers tags service].each do |attr|
        it "does not have :#{attr} attribute" do
          expect(subject.to_json).not_to have_json_path(attr)
        end
      end
    end

    context 'when :without_associations attribute setted to false' do
      let(:ticket) { create(:ticket, without_associations: false) }

      it 'returns true' do
        expect(subject).to receive(:include_associations?).at_least(1).and_return(true)

        subject.to_json
      end

      %w[answers tags service].each do |attr|
        it "has :#{attr} attribute" do
          expect(subject.to_json).to have_json_path(attr)
        end
      end
    end
  end
end
