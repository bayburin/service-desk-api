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
        let!(:service) { create(:service) }
        let(:answer) { attributes_for(:answer) }
        let(:ticket_attrs) { attributes_for(:ticket, service_id: service.id, state: :draft, tags: [{ name: 'test' }]) }
        let(:question_attrs) { attributes_for(:question, answers: [answer], ticket: ticket_attrs) }
        let(:params) { { service_id: service.id, question: question_attrs } }
        let(:quesion) { create(:question) }
        before do
          allow(subject).to receive(:authorize).and_return(true)
          allow(QuestionChangedWorker).to receive(:perform_async)
        end

        it 'calls Tickets::TicketFactory.create method' do
          expect(Tickets::TicketFactory).to receive(:create).with(:question, any_args).and_call_original

          post :create, params: params, format: :json
        end

        it 'calls QuestionChangedWorker worker with id of created ticket' do
          allow(Tickets::TicketFactory).to receive(:create).and_return(quesion)
          expect(QuestionChangedWorker).to receive(:perform_async).with(quesion.id, subject.current_user.tn, 'create', nil)

          post :create, params: params, format: :json
        end

        it 'create new question' do
          expect { post :create, params: params, format: :json }.to change { Question.count }.by(1)
        end

        it 'creates new ticket' do
          expect { post :create, params: params, format: :json }.to change { Ticket.count }.by(1)
        end

        it 'response with created ticket' do
          post :create, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq Question.last.id
        end

        it 'response with success status' do
          post :create, params: params, format: :json

          expect(response.status).to eq 200
        end

        context 'when ticket has errors' do
          before { ticket_attrs[:service_id] = nil }

          it 'does not save ticket' do
            expect { post :create, params: params, format: :json }.not_to change { Ticket.count }
          end

          it 'response with errors status' do
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