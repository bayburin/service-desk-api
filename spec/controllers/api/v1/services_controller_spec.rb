require 'rails_helper'

module Api
  module V1
    RSpec.describe ServicesController, type: :controller do
      # describe 'GET #index' do
      #   let(:category) { create(:category) }
      #   let!(:services) { create_list(:service, 3, category: category) }
      #   let!(:service) { create(:service, category: category, is_hidden: true) }
      #   let(:service_count) { services.size + 1 }
      #   let(:params) { { category_id: category.id } }

      #   before do
      #     create_list(:service, 3)
      #     get :index, params: params, format: :json
      #   end

      #   it 'loads services with specified category_id' do
      #     expect(response.body).to have_json_size(service_count)
      #     parse_json(response.body).each do |s|
      #       expect(s['category_id']).to eq category.id
      #     end
      #   end

      #   # it 'loads only visible services' do
      #   #   parse_json(response.body).each do |t|
      #   #     expect(t['is_hidden']).to be_falsey
      #   #   end
      #   # end

      #   %w[id category_id name short_description install popularity is_hidden has_common_case popularity category].each do |attr|
      #     it "has #{attr} attribute" do
      #       expect(response.body).to have_json_path("0/#{attr}")
      #     end
      #   end

      #   it 'does not load tickets' do
      #     expect(response.body).not_to have_json_path('0/tickets')
      #   end

      #   it 'respond with 200 status' do
      #     expect(response.status).to eq 200
      #   end
      # end

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
