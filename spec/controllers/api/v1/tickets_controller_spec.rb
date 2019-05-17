require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketsController, type: :controller do
      # sign_in_user

      # describe 'GET #index' do
      #   let(:service) { create(:service) }
      #   let!(:tickets) { create_list(:ticket, 3, service: service) }
      #   let!(:common_case) { create(:ticket, service: service, ticket_type: :common_case, is_hidden: true) }
      #   let(:ticket_count) { tickets.size }
      #   let(:params) { { service_id: service.id } }

      #   before { get :index, params: params, format: :json }

      #   it 'loads tickets with specified service_id' do
      #     expect(response.body).to have_json_size(ticket_count)
      #     parse_json(response.body).each do |t|
      #       expect(t['service_id']).to eq service.id
      #     end
      #   end

      #   it 'loads only visible tickets' do
      #     parse_json(response.body).each do |t|
      #       expect(t['is_hidden']).to be_falsey
      #     end
      #   end

      #   %w[id service_id name popularity answers service].each do |attr|
      #     it "has #{attr} attribute" do
      #       expect(response.body).to have_json_path("0/#{attr}")
      #     end
      #   end

      #   it 'includes :category attribute into service' do
      #     expect(response.body).to have_json_path('0/service/category')
      #   end

      #   it 'respond with 200 status' do
      #     expect(response.status).to eq 200
      #   end
      # end

      # describe 'GET #show' do
      #   let(:service) { create(:service) }
      #   let(:tickets) { create_list(:ticket, 3, service: service) }
      #   let!(:ticket) { tickets.first }
      #   let(:params) { { id: ticket.id } }

      #   before { get :show, params: params, format: :json }

      #   it 'loads ticket' do
      #     expect(parse_json(response.body)['id']).to eq ticket.id
      #   end

      #   %w[id service_id name popularity service].each do |attr|
      #     it "has #{attr} attribute" do
      #       expect(response.body).to have_json_path(attr)
      #     end
      #   end

      #   it 'does not include answers' do
      #     expect(response.body).not_to have_json_path('answers')
      #   end

      #   it 'includes :category attribute into service' do
      #     expect(response.body).to have_json_path('service/category')
      #   end

      #   it 'respond with 200 status' do
      #     expect(response.status).to eq 200
      #   end
      # end
    end
  end
end
