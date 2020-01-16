require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe TicketChangedEmailSender do
        let(:operator) { create(:operator_user) }
        let(:manager) { create(:content_manager_user) }
        let(:ticket) { create(:ticket, correction: create(:ticket)) }

        describe '#send' do
          it 'sends email' do
            expect { subject.send(manager, ticket, operator) }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end
    end
  end
end
