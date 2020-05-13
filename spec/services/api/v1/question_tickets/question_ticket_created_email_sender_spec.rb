require 'rails_helper'

module Api
  module V1
    module QuestionTickets
      RSpec.describe QuestionTicketCreatedEmailSender do
        let(:operator) { create(:operator_user) }
        let(:manager) { create(:content_manager_user) }
        let(:question) { create(:question_ticket, correction: create(:question_ticket)) }

        describe '#send' do
          it 'sends email' do
            expect { subject.send(manager, question.ticket, operator, '') }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end
    end
  end
end
