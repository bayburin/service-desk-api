require 'rails_helper'

module Api
  module V1
    RSpec.describe QuestionsQuery, type: :model do
      let!(:tickets) { create_list(:ticket, 7) }
      let!(:ticket) { create(:ticket, ticket_type: :common_case) }
      let!(:correction) { create(:ticket, original: tickets.first, state: :draft) }

      it 'inherits from TicketsQuery class' do
        expect(QuestionsQuery).to be < TicketsQuery
      end

      describe '#all' do
        it 'loads all tickets with :question type' do
          expect(subject.all.count).to eq tickets.count
        end

        it 'runs scope :by_popularity' do
          expect(subject).to receive_message_chain(:questions, :includes, :by_popularity)

          subject.all
        end
      end

      describe '#visible' do
        it 'runs scope :visible' do
          expect(subject).to receive(:visible).and_call_original

          subject.visible
        end

        it 'runs scope :by_popularity' do
          expect(subject).to receive_message_chain(:questions, :visible, :includes, :by_popularity)

          subject.visible
        end
      end

      describe '#most_popular' do
        it 'runs :visible method' do
          expect(subject).to receive(:visible).and_call_original

          subject.most_popular
        end

        it 'limits scope by 5 records' do
          expect(subject.most_popular.count).to eq 5
        end
      end
    end
  end
end
