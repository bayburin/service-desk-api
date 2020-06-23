require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsController, type: :controller do
      sign_in_user
      before { allow(subject).to receive(:authorize) }

      describe 'GET #index' do
        let(:service) { create(:service) }
        let!(:tickets) { create_list(:ticket, 3, :question, service: service, state: :draft) }
        let(:ticket) { create(:ticket, :question) }
        let(:params) { { service_id: service.id } }

        it 'response with questions' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_path('questions')
        end

        it 'response with apps' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_path('apps')
        end

        it 'loads all tickets in service with draft state' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_size(tickets.count).at_path('questions')
        end

        it 'does not load tickets from another service' do
          get :index, params: params, format: :json

          parse_json(response.body)['questions'].each do |q|
            expect(q['id']).not_to eq ticket.ticketable.id
          end
        end

        it 'respond with 200 status' do
          get :index, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
