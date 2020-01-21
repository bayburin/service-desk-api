require 'rails_helper'

module Api
  module V1
    RSpec.describe NotifyContentManagerOnCreate, type: :worker do
      let(:ticket) { create(:ticket) }
      let!(:operator) { create(:operator_user) }
      let!(:manager) { create(:content_manager_user) }
      let(:sender) { double(ReportSender, send_report: true) }
      before do
        allow(User).to receive(:find).with(manager.id).and_return(manager)
        allow(User).to receive(:find).with(operator.id).and_return(operator)
        allow(manager).to receive(:load_details).and_return(manager)
        allow(operator).to receive(:load_details).and_return(operator)
        allow(ReportSender).to receive(:new).and_return(sender)
        allow(sender).to receive(:send_report)
      end

      it 'find user with specified id' do
        expect(User).to receive(:find).with(manager.id).and_return(manager)

        subject.perform(manager.id, ticket.id, operator.id, '')
      end

      it 'calls #load_details method for finded user' do
        expect(manager).to receive(:load_details)

        subject.perform(manager.id, ticket.id, operator.id, '')
      end

      it 'creates instance of ReportSender' do
        expect(ReportSender).to receive(:new).with(manager, ticket, operator, '').and_return(sender)

        subject.perform(manager.id, ticket.id, operator.id, '')
      end

      it 'calls #send_report method for ReportSender instance' do
        expect(sender).to receive(:send_report).with(an_instance_of(Tickets::TicketCreatedEmailSender))

        subject.perform(manager.id, ticket.id, operator.id, '')
      end
    end
  end
end
