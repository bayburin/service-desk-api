require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe QuestionCreatedEmailSender do
        let(:operator) { create(:operator_user) }
        let(:manager) { create(:content_manager_user) }
        let(:question) { create(:question, correction: create(:question)) }

        describe '#send' do
          it 'sends email' do
            expect { subject.send(manager, question.ticket, operator, '') }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end
    end
  end
end
