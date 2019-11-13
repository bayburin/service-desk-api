require 'rails_helper'

module Api
  module V1
    module Services
      RSpec.describe ServiceResponsibleUserSerializer, type: :model do
        let(:service) { create(:service) }
        let!(:ticket) { create(:ticket, service: service) }
        let(:current_user) { create(:user) }
        let(:load_details) { LoadResponsibleDetails.new(service.tickets) }
        subject { ServiceResponsibleUserSerializer.new(service, scope: current_user, scope_name: :current_user) }
        before do
          allow(LoadResponsibleDetails).to receive(:new).and_return(load_details)
          allow(load_details).to receive(:load_details)
        end

        it 'inherits from ServiceBaseSerializer class' do
          expect(ServiceResponsibleUserSerializer).to be < ServiceBaseSerializer
        end

        describe '#tickets' do
          before { allow_any_instance_of(TicketsQuery).to receive_message_chain(:all, :published_state).and_return(service.tickets) }

          it 'calls Tickets::TicketGuestSerializer for :faq association' do
            expect(Tickets::TicketResponsibleUserSerializer).to receive(:new).exactly(service.tickets.count).times.and_call_original

            subject.to_json
          end

          it 'creates instance of Api::V1::ServicesQuery' do
            expect(TicketsQuery).to receive(:new).with(service.tickets).and_call_original

            subject.to_json
          end

          it 'calls :visible and :published_state method' do
            expect_any_instance_of(TicketsQuery).to receive_message_chain(:all, :published_state)

            subject.to_json
          end

          it 'calls :include_authorize_attributes_for method' do
            expect(subject).to receive(:include_authorize_attributes_for).with(service.tickets).and_call_original

            subject.to_json
          end

          it 'creates instance of LoadResponsibleDetails class' do
            expect(LoadResponsibleDetails).to receive(:new).with(service.tickets)

            subject.to_json
          end

          it 'calls #load_details method' do
            expect(load_details).to receive(:load_details)

            subject.to_json
          end

          it 'calls #associate_details! method' do
            expect(load_details).to receive(:associate_details!)

            subject.to_json
          end
        end
      end
    end
  end
end
