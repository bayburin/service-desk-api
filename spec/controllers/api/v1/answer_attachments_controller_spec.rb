require 'rails_helper'

module Api
  module V1
    RSpec.describe AnswerAttachmentsController, type: :controller do
      sign_in_user
      let(:ticket) { create(:ticket) }
      let!(:answer) { ticket.answers.first }
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

      describe 'POST #create' do
        let(:attachment) { attributes_for(:answer_attachment, answer_id: answer.id) }

        it 'creates answer_attachment' do
          expect { post :create, params: attachment }.to change { AnswerAttachment.count }.by(1)
        end

        it 'respond with status 200' do
          post :create, params: attachment

          expect(response.status).to eq 200
        end
      end

      describe 'DELETE #destroy' do
        let!(:attachment) { answer.attachments.first }
        let(:params) { { id: attachment.id, answer_id: attachment.answer_id } }

        it 'destroys answer_attachment' do
          expect { delete :destroy, params: params }.to change { AnswerAttachment.count }.by(-1)
        end

        it 'respond with status 200' do
          delete :destroy, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
