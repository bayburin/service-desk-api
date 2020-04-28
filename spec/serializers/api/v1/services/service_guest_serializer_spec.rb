require 'rails_helper'

module Api
  module V1
    module Services
      RSpec.describe ServiceGuestSerializer, type: :model do
        let(:service) { create(:service) }
        # let!(:ticket) { create(:ticket, service: service) }
        let!(:question) { create(:question_ticket, ticket: create(:ticket, service: service)) }
        let(:current_user) { create(:user) }
        subject { ServiceGuestSerializer.new(service, scope: current_user, scope_name: :current_user) }

        it 'inherits from ServiceBaseSerializer class' do
          expect(ServiceGuestSerializer).to be < ServiceBaseSerializer
        end

        # describe '#tickets' do
        #   before { allow_any_instance_of(TicketsQuery).to receive_message_chain(:visible, :published_state).and_return(service.tickets) }

        #   it 'calls Tickets::TicketGuestSerializer for :tickets association' do
        #     expect(Tickets::TicketGuestSerializer).to receive(:new).exactly(service.tickets.count).times.and_call_original

        #     subject.to_json
        #   end

        #   it 'creates instance of Api::V1::ServicesQuery' do
        #     expect(TicketsQuery).to receive(:new).with(service.tickets).and_call_original

        #     subject.to_json
        #   end

        #   it 'calls :visible and :published_state method' do
        #     expect_any_instance_of(TicketsQuery).to receive_message_chain(:visible, :published_state)

        #     subject.to_json
        #   end

        #   it 'calls :include_authorize_attributes_for method' do
        #     expect(subject).to receive(:include_authorize_attributes_for).with(service.tickets).and_call_original

        #     subject.to_json
        #   end
        # end

        describe '#question_tickets' do
          before { allow_any_instance_of(QuestionTicketsQuery).to receive_message_chain(:visible, :published).and_return(service.question_tickets) }

          it 'call QuestionTickets::QuestionTicketGuestSerializer for :question_tickets association' do
            expect(QuestionTickets::QuestionTicketGuestSerializer).to receive(:new).exactly(service.question_tickets.count).times.and_call_original

            subject.to_json
          end

          it 'creates instance of Api::V1::QuestionTicketsQuery' do
            expect(QuestionTicketsQuery).to receive(:new).with(service.question_tickets).and_call_original

            subject.to_json
          end

          it 'calls :visible and :published method' do
            expect_any_instance_of(QuestionTicketsQuery).to receive_message_chain(:visible, :published)

            subject.to_json
          end

          it 'calls :include_authorize_attributes_for method' do
            expect(subject).to receive(:include_authorize_attributes_for).with(service.question_tickets).and_call_original

            subject.to_json
          end
        end
      end
    end
  end
end
