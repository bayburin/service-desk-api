require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsController, type: :controller do
      sign_in_user
      before { allow(subject).to receive(:authorize) }

      describe 'GET #index' do
        let(:service) { create(:service) }
        let!(:tickets) { create_list(:ticket, 3, service: service, state: :draft) }
        let(:params) { { service_id: service.id, state: 'draft' } }

        it 'loads all tickets in service with specified state' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_size(tickets.count)
        end

        %w[correction responsible_users tags answers/0/attachments].each do |attr|
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
        let(:tickets) { create_list(:ticket, 3, service: service) }
        let!(:ticket) { tickets.first }
        let(:params) { { service_id: ticket.service_id, id: ticket.id } }

        it 'loads ticket' do
          get :show, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq ticket.id
        end

        %w[answers responsible_users tags correction service].each do |attr|
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
        let(:ticket_attrs) { attributes_for(:ticket, service_id: service.id, state: :draft, answers: [answer], tags: [{ name: 'test' }]) }
        let(:params) { { service_id: service.id, ticket: ticket_attrs } }
        before do
          allow(subject).to receive(:authorize).and_return(true)
          allow(NotifyContentManagersWorker).to receive(:perform_async)
        end

        it 'calls Tickets::TicketFactory.create method' do
          expect(Tickets::TicketFactory).to receive(:create).with(:question, any_args).and_call_original

          post :create, params: params, format: :json
        end

        it 'creates new ticket' do
          expect { post :create, params: params, format: :json }.to change { Ticket.count }.by(1)
        end

        it 'response with created ticket' do
          post :create, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq Ticket.last.id
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
        let!(:ticket) { create(:ticket) }
        let(:ticket_params) { ticket.as_json(include: %i[answers tags responsible_users]) }
        let(:params) { { service_id: ticket.service.id, id: ticket.id, ticket: ticket_params } }
        let(:decorator) { TicketDecorator.new(ticket) }
        before do
          allow(TicketDecorator).to receive(:new).with(ticket).and_return(decorator)
          allow(NotifyContentManagersWorker).to receive(:perform_async)
        end

        it 'calls update_by_state method' do
          expect(decorator).to receive(:update_by_state).and_return(true)

          put :update, params: params, format: :json
        end

        it 'calls NotifyContentManagersWorker worker with id of ticket' do
          allow_any_instance_of(UserPolicy).to receive(:send_ticket_notification?).and_return(true)
          expect(NotifyContentManagersWorker).to receive(:perform_async).with(ticket.id, subject.current_user.id, 'update', nil)

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
          allow_any_instance_of(QuestionsQuery).to receive(:waiting_for_publish).and_return([ticket])
          # expect(ticket).to receive(:publish).and_call_original

          post :publish, params: params, format: :json

          expect(ticket.reload.published_state?).to be_truthy
        end
      end
    end
  end
end
