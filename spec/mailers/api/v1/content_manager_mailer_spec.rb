require "rails_helper"

module Api
  module V1
    RSpec.describe ContentManagerMailer, type: :mailer do
      let(:operator) { create(:operator_user) }
      let(:manager) { create(:content_manager_user) }
      let(:ticket) { create(:ticket, correction: create(:ticket)) }
      let(:mail) { ContentManagerMailer.question_changed_email(manager, ticket, operator) }

      it 'renders the subject' do
        expect(mail.subject).to eq("Портал \"Техподдержка УИВТ\": вопрос №#{ticket.id} изменен")
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([manager.details.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['monitoring@iss-reshetnev.ru'])
      end
    end
  end
end
