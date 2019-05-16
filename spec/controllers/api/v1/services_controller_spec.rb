require 'rails_helper'

module Api
  module V1
    RSpec.describe ServicesController, type: :controller do
      sign_in_user

      describe 'GET #index' do
        let!(:services) { create_list(:service, 3) }

        before { get :index, format: :json }

        it 'loads all services' do
          expect(response.body).to have_json_size(3)
        end

        it 'loads answers for :tickets attribute' do
          expect(response.body).not_to have_json_path('0/tickets/0/answers')
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end

      describe 'GET #show' do
        let(:category) { create(:category) }
        let(:services) { create_list(:service, 3, category: category) }
        let!(:service) { services.first }
        let!(:ticket) { create(:ticket, ticket_type: :common_case, service: service) }
        let!(:tickets) { create_list(:ticket, 3, ticket_type: :question, service: service) }
        let(:params) { { category_id: category.id, id: service.id } }

        before { get :show, params: params, format: :json }

        it 'loads service with specified service_id' do
          expect(parse_json(response.body)['id']).to eq service.id
        end

        it 'loads answers for :tickets attribute' do
          expect(response.body).to have_json_path('tickets/0/answers')
        end

        it 'runs ServiceSerializer' do
          expect(response.body).to eq ServiceSerializer.new(service).to_json(include: [:category, tickets: :answers])
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end
    end
  end
end
