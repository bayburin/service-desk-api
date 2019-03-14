require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsController, type: :controller do
      describe 'GET #index' do
        let(:service) { create(:service) }
        let!(:tickets) { create_list(:ticket, 3, service: service) }
        let(:params) { { service_id: service.id } }

        it 'loads all tickets with specified service_id' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_size(service.tickets.count)
          parse_json(response.body).each do |t|
            expect(t['service_id']).to eq service.id
          end
        end

        %w[id service_id ticket popularity solutions tags].each do |attr|
          it "has #{attr} attribute" do
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
        let!(:tickets) { create_list(:ticket, 3, service: service) }
        let(:selected_ticket) { tickets.first }
        let(:solutions) { create_list(:solution, 3, ticket: selected_ticket) }
        let(:params) { { service_id: service.id, id: selected_ticket.id } }

        it 'loads ticket' do
          get :show, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq selected_ticket.id
        end

        it 'loads all solutions for ticket' do
          get :show, params: params, format: :json

          expect(response.body).to have_json_path('solutions')
        end
      end
    end
  end
end
