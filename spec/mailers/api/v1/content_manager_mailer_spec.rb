require "rails_helper"

module Api
  module V1
    RSpec.describe ContentManagerMailer, type: :mailer do
      let(:operator) { create(:operator_user) }
      let(:manager) { create(:content_manager_user) }
      let(:question) { create(:question, correction: create(:question)) }
      let(:mail) { ContentManagerMailer.question_updated_email(manager, question.ticket, operator, '') }

      it 'renders the subject' do
        expect(mail.subject).to eq("Портал \"Техподдержка УИВТ\": вопрос №#{question.ticket.id} изменен")
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([manager.details.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['uivt06@iss-reshetnev.ru'])
      end
    end
  end
end
