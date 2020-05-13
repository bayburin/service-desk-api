require 'rails_helper'

module Api
  module V1
    RSpec.describe NotifyContentManagerOnUpdateQuestion, type: :worker do
      let(:ticket) { create(:ticket) }
      let!(:operator) { create(:operator_user) }
      let!(:manager) { create(:content_manager_user) }
      let(:sender) { double(ReportSender, send_report: true) }
      before do
        allow(User).to receive(:find).with(manager.id).and_return(manager)
        # allow(User).to receive(:find).with(operator.id).and_return(operator)
        allow(User).to receive(:authenticate).with(tn: operator.tn).and_return(operator)
        allow(manager).to receive(:load_details).and_return(manager)
        allow(operator).to receive(:load_details).and_return(operator)
        allow(ReportSender).to receive(:new).and_return(sender)
        allow(sender).to receive(:send_report)
      end

      it 'find user with specified id' do
        expect(User).to receive(:find).with(manager.id).and_return(manager)

        subject.perform(manager.id, ticket.id, operator.tn, '')
      end

      it 'calls #load_details method for finded user' do
        expect(manager).to receive(:load_details)

        subject.perform(manager.id, ticket.id, operator.tn, '')
      end

      it 'creates instance of ReportSender' do
        expect(ReportSender).to receive(:new).with(manager, ticket, operator, '').and_return(sender)

        subject.perform(manager.id, ticket.id, operator.tn, '')
      end

      it 'calls #send_report method for ReportSender instance' do
        expect(sender).to receive(:send_report).with(an_instance_of(QuestionTickets::QuestionTicketUpdatedEmailSender))

        subject.perform(manager.id, ticket.id, operator.tn, '')
      end

      context 'when delivery_user and current_user is the same' do
        before { allow(User).to receive(:authenticate).with(tn: manager.tn).and_return(manager) }

        it 'does not call #send_report method' do
          expect(sender).not_to receive(:send_report)

          subject.perform(manager.id, ticket.id, manager.tn, '')
        end
      end
    end
  end
end
