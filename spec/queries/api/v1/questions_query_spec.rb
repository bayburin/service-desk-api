require 'rails_helper'

module Api
  module V1
    RSpec.describe QuestionsQuery, type: :model do
      let!(:apps) { create_list(:ticket, 2, :app) }
      let!(:questions) { create_list(:question, 7) }
      let(:question) { create(:question) }
      let!(:correction) { create(:question, original: question, state: :draft) }

      it 'inherits from TicketsQuery class' do
        expect(described_class).to be < ApplicationQuery
      end

      context 'when scope exists' do
        let(:scope) { Question.limit(2) }
        subject { QuestionsQuery.new(scope) }

        it 'use current scope' do
          expect(subject.scope.map(&:id)).to eq scope.map(&:id)
        end

        it 'join ticket table' do
          expect(scope).to receive(:includes).with(:ticket)

          QuestionsQuery.new(scope)
        end
      end

      context 'when scope does not exist' do
        it 'create scope' do
          expect(subject.scope.map(&:id)).to eq Question.all.map(&:id)
        end
      end

      describe '#all' do
        it 'load all questions' do
          expect(subject.all.count).to eq questions.count + 1
        end

        it 'call scope :by_popularity' do
          expect(subject).to receive_message_chain(:questions, :includes, :by_popularity)

          subject.all
        end
      end

      describe '#visible' do
        it 'call scope :visible' do
          expect(subject).to receive(:visible).and_call_original

          subject.visible
        end

        it 'call scope :by_popularity' do
          expect(subject).to receive_message_chain(:questions, :visible, :by_popularity)

          subject.visible
        end
      end

      describe '#most_popular' do
        it 'call :visible and :published method' do
          expect(subject).to receive_message_chain(:visible, :published, :by_visible_service, :limit)

          subject.most_popular
        end

        it 'limit scope by 5 records' do
          expect(subject.most_popular.count).to eq 5
        end
      end

      describe '#waiting_for_publish' do
        it 'return questions with draft state and specified id' do
          expect(subject.waiting_for_publish(correction.id).count).to eq 1

          subject.waiting_for_publish(correction.id).each do |q|
            expect(q.ticket.draft_state?).to be_truthy
            expect(q.id).to eq correction.id
          end
        end
      end

      describe '#all_in_service' do
        let(:service) { create(:service) }
        let!(:ticket) { create(:ticket, :question, is_hidden: true, service: service) }
        let!(:extra_service) { create(:service) }
        let!(:service_tickets) { service.tickets.where(ticketable_type: :Question) }
        let(:result) { subject.all_in_service(service) }

        it 'returns all tickets from specified service' do
          expect(result.length).to eq service_tickets.count
          expect(result).to include(*service_tickets.map(&:ticketable), ticket.ticketable)
          expect(result).not_to include(*extra_service.tickets(&:ticketable))
        end
      end
    end
  end
end
