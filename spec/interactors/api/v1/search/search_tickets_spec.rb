require 'rails_helper'

module Api
  module V1
    module Search
      RSpec.describe SearchTickets do
        let(:term) { 'search term' }
        let!(:tickets) { create_list(:ticket, 2, :question, without_nested: true) }
        let!(:tickets_term) { create_list(:ticket, 3, :question, name: term, without_nested: true) }
        let!(:questions_term) { tickets_term.map(&:ticketable) }
        let!(:common_case) { create(:ticket, :common_case, without_nested: true) }
        let!(:filtered_ticket) { create(:ticket, :question, without_nested: true) }
        let(:finded_by_sphinx) { tickets_term + [filtered_ticket] + [common_case] }
        let(:filtered_by_policy) { tickets_term + [common_case] }
        let(:json_questions) { questions_term.as_json }
        let(:current_user) { create(:content_manager_user) }
        subject(:context) { described_class.call(user: current_user, term: term) }
        before do
          allow(Ticket).to receive(:search).and_return(finded_by_sphinx)
          allow_any_instance_of(TicketPolicy::SphinxScope).to receive(:resolve).and_return(filtered_by_policy)
          allow_any_instance_of(ActiveModel::Serializer::CollectionSerializer).to receive(:as_json).and_return(json_questions)
        end

        describe '.call' do
          it 'filter finded tickets by policy' do
            expect(TicketPolicy::SphinxScope).to receive(:new).with(current_user, finded_by_sphinx).and_call_original
            expect_any_instance_of(TicketPolicy::SphinxScope).to receive(:resolve).and_return(filtered_by_policy)

            context
          end

          it 'filter finded tickets by ticketable_type to set questions' do
            expect(context.questions.all? { |t| t.is_a? Question }).to be_truthy
          end

          it 'save into questions context' do
            expect(context.questions.map(&:id)).to eq tickets_term.map(&:ticketable_id)
          end

          it 'serialize finded questions' do
            expect(ActiveModel::Serializer::CollectionSerializer).to(
              receive(:new).with(questions_term, serializer: Questions::QuestionResponsibleUserSerializer).and_call_original
            )
            expect_any_instance_of(ActiveModel::Serializer::CollectionSerializer).to receive(:as_json).and_return(json_questions)

            context
          end

          it 'save into result context finded services at json format' do
            expect(context.result).to eq json_questions
          end
        end
      end
    end
  end
end
