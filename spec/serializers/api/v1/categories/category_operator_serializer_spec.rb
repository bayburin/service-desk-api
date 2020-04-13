require 'rails_helper'

module Api
  module V1
    module Categories
      RSpec.describe CategoryOperatorSerializer, type: :model do
        let(:current_user) { create(:operator_user) }
        let(:category) { create(:category) }
        subject { CategoryOperatorSerializer.new(category, scope: current_user, scope_name: :current_user) }

        it 'inherits from CategoryBaseSerializer class' do
          expect(CategoryOperatorSerializer).to be < CategoryBaseSerializer
        end

        describe '#services' do
          it 'calls Services::ServiceResponsibleUserSerializer for :services association' do
            expect(Services::ServiceResponsibleUserSerializer).to receive(:new).exactly(category.services.count).times.and_call_original

            subject.to_json
          end
        end

        describe '#faq' do
          before { create_list(:service, 2, category: category) }

          it 'calls QuestionTickets::QuestionTicketResponsibleUserSerializer for :faq association' do
            expect(QuestionTickets::QuestionTicketResponsibleUserSerializer).to receive(:new).exactly(5).times.and_call_original

            subject.to_json
          end

          it 'create instance of Api::V1::QuestionTicketsQuery' do
            expect(Api::V1::QuestionTicketsQuery).to receive(:new).with(category.question_tickets.includes(ticket: :responsible_users, answers: :attachments)).and_call_original

            subject.to_json
          end

          it 'calls :most_popular method' do
            # expect_any_instance_of(Api::V1::QuestionTicketsQuery).to receive_message_chain(:most_popular, :includes)
            expect_any_instance_of(Api::V1::QuestionTicketsQuery).to receive(:most_popular)

            subject.to_json
          end
        end
      end
    end
  end
end
