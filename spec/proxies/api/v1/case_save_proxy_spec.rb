require 'rails_helper'

module Api
  module V1
    RSpec.describe CaseSaveProxy, type: :model do
      let(:item_id) { 999 }
      let(:invent_num) { 'new invent num' }
      let(:common_ticket) { create(:ticket, ticket_type: :common_case) }
      let(:connect_ticket) { create(:ticket, ticket_type: :case) }
      let!(:service) { create(:service, tickets: [common_ticket, connect_ticket]) }
      let!(:kase) { build(:case, host_id: nil, item_id: nil, service: service) }

      subject { CaseSaveProxy.new(kase) }

      before do
        stub_request(:post, 'https://astraea-ui.iss-reshetnev.ru/api/cases.json').to_return(status: 200, body: '', headers: {})
      end

      it 'receives :method_missing method' do
        expect(subject).to receive(:method_missing)

        subject.save
      end

      it 'respond_to save method' do
        expect(subject.respond_to?(:save)).to be_truthy
      end

      context 'when ticket_id is not defined' do
        before { kase.ticket_id = nil }

        it 'adds :ticket_id attribute from :common_case type' do
          subject.save

          expect(subject.kase.ticket_id).to eq common_ticket.id
        end

        it 'adds :sla attribute from :common_case type' do
          subject.save

          expect(subject.kase.sla).to eq common_ticket.sla
        end

        it 'adds responsible users from :common_case type' do
          subject.save

          expect(subject.kase.accs).to match_array(common_ticket.responsible_users.pluck(:tn))
        end
      end

      context 'when ticket_id is defined' do
        before { kase.ticket_id = connect_ticket.id }

        it 'adds responsible users from current ticket' do
          subject.save

          expect(subject.kase.accs).to match_array(connect_ticket.responsible_users.pluck(:tn))
        end
      end

      context 'when :common_case is not defined' do
        before { allow(subject).to receive(:find_ticket).and_return(nil) }

        it 'returns true' do
          expect(subject.save).to be_truthy
        end
      end

      context 'when responsible_users is empty' do
        before { allow(subject).to receive_message_chain(:find_ticket, :responsible_users).and_return([]) }

        it 'sets empty array to :accs attribute' do
          subject.save

          expect(subject.kase.accs).to be_empty
        end
      end
    end
  end
end
