require 'rails_helper'

module Api
  module V1
    RSpec.describe QuestionTicketsQuery, type: :model do
      let!(:questions) { create_list(:question_ticket, 7) }
      let!(:correction) { create(:question_ticket, original: questions.first, state: :draft) }

      it 'inherits from TicketsQuery class' do
        expect(QuestionTicketsQuery).to be < ApplicationQuery
      end

      context 'when scope exists' do
        let(:scope) { QuestionTicket.limit(2) }
        subject { QuestionTicketsQuery.new(scope) }

        it 'use current scope' do
          expect(subject.scope.map(&:id)).to eq scope.map(&:id)
        end

        it 'join ticket table' do
          expect(scope).to receive(:includes).with(:ticket)

          QuestionTicketsQuery.new(scope)
        end
      end

      context 'when scope does not exist' do
        it 'create scope' do
          expect(subject.scope.map(&:id)).to eq QuestionTicket.all.map(&:id)
        end
      end

      describe '#all' do
        it 'load all question_tickets' do
          expect(subject.all.count).to eq questions.count
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
        it 'return tickets with draft state and specified id' do
          subject.waiting_for_publish(correction.id).each do |q|
            expect(q.ticket.draft_state?).to be_truthy
            expect(q.id).to eq correction.id
          end
        end
      end
    end
  end
end
