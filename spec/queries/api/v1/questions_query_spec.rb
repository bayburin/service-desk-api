require 'rails_helper'

module Api
  module V1
    RSpec.describe QuestionsQuery, type: :model do
      let!(:tickets) { create_list(:ticket, 5) }
      let!(:ticket) { create(:ticket, ticket_type: :common_case) }
      subject { QuestionsQuery.new }

      it 'inherits from TicketsQuery class' do
        expect(QuestionsQuery).to be < TicketsQuery
      end

      describe '#all' do
        it 'loads all tickets with :question type' do
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
