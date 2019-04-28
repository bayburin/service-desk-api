require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsQuery, type: :model do
      let!(:tickets) { create_list(:ticket, 5) }
      let!(:ticket) { create(:ticket, ticket_type: :common_case) }

      it 'inherits from ApplicationQuery class' do
        expect(TicketsQuery).to be < ApplicationQuery
      end

      context 'when scope does not exist' do
        it 'creates scope' do
          expect(subject.scope).to eq Ticket.all
        end
      end

      context 'when scope exists' do
        let(:scope) { Ticket.first(2) }
        subject { TicketsQuery.new(scope) }

        it 'use current scope' do
          expect(subject.scope).to eq scope
        end
      end

      describe '#all' do
        it 'loads all tickets except tickets with :common_case type' do
          expect(subject.all.count).to eq tickets.count
        end

        it 'runs scope :by_popularity' do
          expect(subject.scope).to receive(:by_popularity)

          subject.all
        end
      end
    end
  end
end
