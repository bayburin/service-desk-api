require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsQuery, type: :model do
      let(:service) { create(:service) }
      let!(:tickets) { create_list(:ticket, 5, :question, service: service) }
      let!(:common_ticket) { create(:ticket, :common_case, service: service) }
      let(:scope) { service.tickets }
      subject { TicketsQuery.new(scope) }

      it 'inherits from ApplicationQuery class' do
        expect(TicketsQuery).to be < ApplicationQuery
      end

      context 'when scope exists' do
        it 'use current scope' do
          expect(subject.scope).to eq scope
        end
      end

      context 'when scope does not exist' do
        subject { TicketsQuery.new }

        it 'creates scope' do
          expect(subject.scope).to eq Ticket.all
        end
      end

      describe '#all' do
        it 'loads all tickets except tickets with :common_case type' do
          expect(subject.all.count).to eq service.tickets.where.not(ticketable_type: :CommonCaseTicket).count
        end

        it 'runs scope :by_popularity' do
          expect(subject).to receive_message_chain(:tickets, :by_popularity)

          subject.all
        end
      end

      describe '#visible' do
        let!(:hidden_ticket) { create(:ticket, :question, is_hidden: true, service: service) }

        it 'loads all tickets except tickets with :common_case type and :is_hidden attribute' do
          expect(subject.visible.count).to eq service.tickets.where.not(ticketable_type: :CommonCaseTicket).count - 1
          expect(subject.visible).not_to include(hidden_ticket)
        end

        it 'runs scope :visible' do
          expect(subject).to receive(:visible).and_call_original

          subject.visible
        end
      end

      describe '#by_responsible' do
        let!(:new_ticket) { create(:ticket, :question, service: service, is_hidden: true) }
        let!(:hidden_ticket) { create(:ticket, :question, is_hidden: true, service: service) }
        let!(:user) { create(:service_responsible_user, tickets: [new_ticket]) }

        it 'returns all records in which user is responsible and all visible records' do
          expect(subject.by_responsible(user).length).to eq 2 + tickets.count + 1
          expect(subject.by_responsible(user)).to include(new_ticket)
          expect(subject.by_responsible(user)).not_to include(hidden_ticket)
        end
      end

      describe 'all_in_service' do
        let!(:ticket) { create(:ticket, :question, is_hidden: true, service: service) }
        let!(:extra_service) { create(:service) }
        let!(:service_tickets) { service.tickets.where(ticketable_type: :QuestionTicket) }
        let(:result) { subject.all_in_service(service) }

        it 'returns all tickets from specified service' do
          expect(result.length).to eq service_tickets.count
          expect(result).to include(*service_tickets, ticket)
          expect(result).not_to include(*extra_service.tickets)
        end
      end
    end
  end
end
