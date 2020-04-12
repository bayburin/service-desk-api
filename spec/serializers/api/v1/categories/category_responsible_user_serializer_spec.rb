require 'rails_helper'

module Api
  module V1
    module Categories
      RSpec.describe CategoryResponsibleUserSerializer, type: :model do
        let(:current_user) { create(:service_responsible_user) }
        let(:category) { create(:category) }
        subject { CategoryResponsibleUserSerializer.new(category, scope: current_user, scope_name: :current_user) }

        it 'inherits from CategoryBaseSerializer class' do
          expect(CategoryResponsibleUserSerializer).to be < CategoryBaseSerializer
        end

        describe '#services' do
          it 'calls Services::ServiceResponsibleUserSerializer for :services association' do
            expect(Services::ServiceResponsibleUserSerializer).to receive(:new).exactly(category.services.count).times.and_call_original

            subject.to_json
          end
        end

        describe '#faq' do
          before { create_list(:service, 2, category: category) }

          it 'calls Tickets::TicketSerializer for :faq association' do
            expect(Tickets::TicketSerializer).to receive(:new).exactly(5).times.and_call_original

            subject.to_json
          end

          it 'create instance of Api::V1::QuestionTicketsQuery' do
            expect(Api::V1::QuestionTicketsQuery).to receive(:new).with(category.tickets.includes(:responsible_users, answers: :attachments)).and_call_original

            subject.to_json
          end

          it 'calls :most_popular method' do
            expect_any_instance_of(Api::V1::QuestionTicketsQuery).to receive_message_chain(:most_popular, :includes)

            subject.to_json
          end
        end
      end
    end
  end
end
