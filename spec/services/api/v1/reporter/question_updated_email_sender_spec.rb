require 'rails_helper'

module Api
  module V1
    module Reporter
      RSpec.describe QuestionUpdatedEmailSender do
        let(:operator) { create(:operator_user) }
        let(:manager) { create(:content_manager_user) }
        let(:question) { create(:question, correction: create(:question)) }
        let(:origin) { '' }
        let(:params) { { current_user: operator, origin: origin } }

        describe '#send' do
          it 'sends email' do
            expect { subject.send(manager, question.ticket, **params) }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end
    end
  end
end
