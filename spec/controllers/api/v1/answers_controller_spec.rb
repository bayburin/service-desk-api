require 'rails_helper'

module Api
  module V1
    RSpec.describe AnswersController, type: :controller do
      sign_in_user

      describe 'GET #download_attachment' do
        let(:ticket) { create(:ticket) }
        let!(:answer) { ticket.answers.first }
        let(:attachment) { answer.attachments.first }
        let(:params) { { id: answer.id, attachment_id: attachment.id } }

        it 'sends file' do
          expect(subject).to receive(:send_file).with(attachment.document.file.file)

          get :download_attachment, params: params, format: :json
        end
      end
    end
  end
end
