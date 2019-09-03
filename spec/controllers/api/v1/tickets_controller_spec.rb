require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsController, type: :controller do
      sign_in_user

      describe 'GET #show' do
        let(:service) { create(:service) }
        let(:tickets) { create_list(:ticket, 3, service: service) }
        let!(:ticket) { tickets.first }
        let(:params) { { service_id: ticket.service_id, id: ticket.id } }

        before { ticket.without_associations! }

        it 'loads ticket' do
          get :show, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq ticket.id
        end

        it 'runs TicketSerializer' do
          expect(TicketSerializer).to receive(:new).and_call_original

          get :show, params: params, format: :json
        end

        it 'changes popularity of selected ticket' do
          expect { get :show, params: params, format: :json }.to change { ticket.reload.popularity }.by(1)
        end

        %w[answers service].each do |attr|
          it "does not have :#{attr} attribute" do
            get :show, params: params, format: :json

            expect(response.body).not_to have_json_path(attr)
          end
        end

        it 'respond with 200 status' do
          get :show, params: params, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'POST #create' do
        let!(:service) { create(:service) }
        let(:ticket_attrs) { attributes_for(:ticket, service_id: service.id) }
        let(:params) { { service_id: service.id, ticket: ticket_attrs } }

        it 'creates new ticket' do
          expect { post :create, params: params, format: :json }.to change { Ticket.count }.by(1)
        end

        it 'sets default params' do
          post :create, params: params, format: :json

          expect(Ticket.last.ticket_type).to eq 'question'
          expect(Ticket.last.state).to eq 'draft'
          expect(Ticket.last.to_approve).to be_falsey
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

          # it 'response with ticket errors' do
          #   post :create, params: params, format: :json

          #   p response.body
          # end
        end
      end
    end
  end
end
