require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsQuery, type: :model do
      let(:service) { create(:service) }
      let!(:tickets) { create_list(:ticket, 5, service: service) }
      let!(:ticket) { create(:ticket, ticket_type: :common_case) }
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
          expect(subject.all.count).to eq tickets.count
        end

        it 'runs scope :by_popularity' do
          expect(subject).to receive_message_chain(:tickets, :by_popularity)

          subject.all
        end
      end

      describe '#visible' do
        it 'runs scope :visible' do
          expect(subject).to receive(:visible).and_call_original

          subject.visible
        end

        it 'runs scope :by_popularity' do
          expect(subject).to receive_message_chain(:tickets, :visible, :by_popularity)

          subject.visible
        end
      end
    end
  end
end
