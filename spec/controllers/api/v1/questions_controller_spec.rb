require 'rails_helper'

module Api
  module V1
    RSpec.describe QuestionsController, type: :controller do
      sign_in_user
      before { allow(subject).to receive(:authorize) }

      describe 'GET #index' do
        let(:service) { create(:service) }
        let!(:tickets) { create_list(:ticket, 3, :question, service: service, state: :draft) }
        let(:params) { { service_id: service.id, state: 'draft' } }

        it 'loads all tickets in service with specified state' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_size(tickets.count)
        end

        %w[correction ticket/responsible_users ticket/tags answers/0/attachments].each do |attr|
          it "has :#{attr} attribute" do
            get :index, params: params, format: :json

            expect(response.body).to have_json_path("0/#{attr}")
          end
        end

        it 'respond with 200 status' do
          get :index, params: params, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #show' do
        let(:service) { create(:service) }
        let(:ticket) { create(:ticket, :question, service: service) }
        let(:question) { ticket.ticketable }
        let(:params) { { service_id: ticket.service_id, id: question.id } }

        it 'loads ticket' do
          get :show, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq question.id
        end

        %w[answers ticket/responsible_users ticket/tags correction ticket/service].each do |attr|
          it "has :#{attr} attribute" do
            get :show, params: params, format: :json

            expect(response.body).to have_json_path(attr)
          end
        end

        it 'respond with 200 status' do
          get :show, params: params, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'POST #create' do
        let(:service) { create(:service) }
        let(:question) { create(:question) }
        let(:params) { { service_id: service.id, question: question.as_json } }
        before do
          allow(Questions::Create).to receive(:call).and_return(create_dbl)
          allow(QuestionChangedWorker).to receive(:perform_async)
        end

        context 'when question was created' do
          let(:create_dbl) { double(:create, success?: true, question: question) }

          it 'call Questions::Create#call method' do
            expect(Questions::Create).to receive(:call)

            post :create, params: params, format: :json
          end

          it 'response with created ticket' do
            post :create, params: params, format: :json

            expect(parse_json(response.body)['id']).to eq question.id
          end

          it 'response with success status' do
            post :create, params: params, format: :json

            expect(response.status).to eq 200
          end
        end

        context 'when question was not created' do
          let(:create_dbl) { double(:create, success?: false, errors: { message: 'test' }) }

          it 'response with error message' do
            post :create, params: params, format: :json

            expect(response.body).to eq create_dbl.errors.to_json
          end

          it 'response with error status' do
            post :create, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end

      describe 'PUT #update' do
        let!(:question) { create(:question) }
        let(:question_params) { question.as_json(include: [:answers, ticket: { include: %i[tags responsible_users] }]) }
        let(:params) { { service_id: question.service.id, id: question.id, question: question_params } }
        let(:decorator) { QuestionDecorator.new(question) }
        before do
          allow(QuestionDecorator).to receive(:new).with(question).and_return(decorator)
          allow(QuestionChangedWorker).to receive(:perform_async)
        end

        it 'calls update_by_state method' do
          expect(decorator).to receive(:update_by_state).and_return(true)

          put :update, params: params, format: :json
        end

        it 'calls QuestionChangedWorker worker with id of ticket' do
          expect(QuestionChangedWorker).to receive(:perform_async).with(question.id, subject.current_user.tn, 'update', nil)

          put :update, params: params, format: :json
        end

        it 'respond with 200 status' do
          put :update, params: params, format: :json

          expect(response.status).to eq 200
        end

        context 'when ticket was not updated' do
          before { expect(decorator).to receive(:update_by_state).and_return(false) }

          it 'respond with 422 status' do
            put :update, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end

      describe 'DELETE #destroy' do
        let!(:question) { create(:question) }
        let(:params) { { service_id: question.service.id, id: question.id } }
        let(:decorator) { QuestionDecorator.new(question) }
        before { allow(QuestionDecorator).to receive(:new).with(question).and_return(decorator) }

        it 'call destroy_by_state method' do
          expect(decorator).to receive(:destroy_by_state).and_return(true)

          delete :destroy, params: params, format: :json
        end

        it 'respond with 200 status' do
          delete :destroy, params: params, format: :json

          expect(response.status).to eq 200
        end

        context 'when ticket was not updated' do
          before { expect(decorator).to receive(:destroy_by_state).and_return(false) }

          it 'respond with 422 status' do
            delete :destroy, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end

      describe 'POST #raise_rating' do
        let(:service) { create(:service) }
        let(:tickets) { create_list(:ticket, 3, service: service) }
        let!(:ticket) { tickets.first }
        let(:params) { { service_id: ticket.service_id, id: ticket.id } }

        before { ticket.without_associations! }

        it 'changes popularity of selected ticket' do
          expect { post :raise_rating, params: params, format: :json }.to change { ticket.reload.popularity }.by(1)
        end

        it 'respond with 204 status' do
          post :raise_rating, params: params, format: :json

          expect(response.status).to eq 204
        end
      end

      describe 'POST #publish' do
        let!(:question) { create(:question, state: :draft) }
        let(:params) { { ids: question.id.to_s } }
        before { allow_any_instance_of(QuestionsQuery).to receive(:waiting_for_publish).and_return([question]) }

        it 'change state of specified tickets' do
          post :publish, params: params, format: :json

          expect(question.ticket.reload.published_state?).to be_truthy
        end

        it 'respond with 200 status' do
          post :publish, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
