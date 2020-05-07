require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsController, type: :controller do
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
        let(:question_attrs) { attributes_for(:question_ticket, answers: [answer], ticket: ticket_attrs) }
        let(:params) { { service_id: service.id, question: question_attrs } }
        let(:quesion) { create(:question_ticket) }
        before do
          allow(subject).to receive(:authorize).and_return(true)
          allow(NotifyContentManagersWorker).to receive(:perform_async)
        end

        it 'calls Tickets::TicketFactory.create method' do
          expect(Tickets::TicketFactory).to receive(:create).with(:question, any_args).and_call_original

          post :create, params: params, format: :json
        end

        it 'calls NotifyContentManagersWorker worker with id of created ticket' do
          allow(Tickets::TicketFactory).to receive(:create).and_return(quesion)
          expect(NotifyContentManagersWorker).to receive(:perform_async).with(quesion.id, subject.current_user.tn, 'create', nil)

          post :create, params: params, format: :json
        end

        it 'create new question_ticket' do
          expect { post :create, params: params, format: :json }.to change { QuestionTicket.count }.by(1)
        end

        it 'creates new ticket' do
          expect { post :create, params: params, format: :json }.to change { Ticket.count }.by(1)
        end

        it 'response with created ticket' do
          post :create, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq QuestionTicket.last.id
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
        let!(:question) { create(:question_ticket) }
        let(:question_params) { question.as_json(include: [:answers, ticket: { include: %i[tags responsible_users] }]) }
        let(:params) { { service_id: question.service.id, id: question.id, question: question_params } }
        let(:decorator) { QuestionTicketDecorator.new(question) }
        before do
          allow(QuestionTicketDecorator).to receive(:new).with(question).and_return(decorator)
          allow(NotifyContentManagersWorker).to receive(:perform_async)
        end

        it 'calls update_by_state method' do
          expect(decorator).to receive(:update_by_state).and_return(true)

          put :update, params: params, format: :json
        end

        it 'calls NotifyContentManagersWorker worker with id of ticket' do
          expect(NotifyContentManagersWorker).to receive(:perform_async).with(question.id, subject.current_user.tn, 'update', nil)

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
        let!(:ticket) { create(:ticket) }
        let(:params) { { service_id: ticket.service.id, id: ticket.id } }
        let(:decorator) { TicketDecorator.new(ticket) }
        before { allow(TicketDecorator).to receive(:new).with(ticket).and_return(decorator) }

        it 'calls destroy_by_state method' do
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
        let(:service) { create(:service) }
        let!(:ticket) { create(:ticket, service: service, state: :draft) }
        let(:params) { { ids: ticket.id.to_s } }

        it 'change state of specified tickets' do
          allow_any_instance_of(QuestionTicketsQuery).to receive(:waiting_for_publish).and_return([ticket])
          # expect(ticket).to receive(:publish).and_call_original

          post :publish, params: params, format: :json

          expect(ticket.reload.published_state?).to be_truthy
        end
      end
    end
  end
end
