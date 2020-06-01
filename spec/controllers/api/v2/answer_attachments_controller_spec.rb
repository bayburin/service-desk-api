require 'rails_helper'

module Api
  module V2
    RSpec.describe AnswerAttachmentsController, type: :controller do
      sign_in_guest_user
      let(:question) { create(:question) }
      let!(:answer) { question.answers.first }
      before { allow(subject).to receive(:authorize) }

      describe 'GET #show' do
        let(:attachment) { answer.attachments.first }
        let(:params) { { answer_id: answer.id, id: attachment.id } }

        it 'sends file' do
          expect(subject).to receive(:send_file).with(attachment.document.file.file)

          get :show, params: params, format: :json
        end

        it 'respond with status 200' do
          get :show, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
