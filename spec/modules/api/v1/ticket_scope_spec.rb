require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketScope do
      subject { Ticket.extend(TicketScope) }

      describe '#published' do
        let!(:draft_ticket) { create(:ticket, state: :draft) }
        let!(:published_ticket) { create(:ticket) }

        it 'return instance of ActiveRecord::Relation' do
          expect(subject.published).to be_kind_of(ActiveRecord::Relation)
        end

        it 'return only record with :published state' do
          expect(subject.published.first).to eq published_ticket
        end
      end

      describe '#by_visible_service' do
        let(:tickets) { create_list(:ticket, 3) }
        let(:service) { create(:service, without_nested: true, is_hidden: true) }
        let(:ticket) { create(:ticket, service: service) }

        it 'return instance of ActiveRecord::Relation' do
          expect(subject.by_visible_service).to be_kind_of(ActiveRecord::Relation)
        end

        it 'return tickets if service is visible' do
          expect(subject.by_visible_service).to include(*tickets)
          expect(subject.by_visible_service).not_to include(ticket)
        end
      end
    end
  end
end
