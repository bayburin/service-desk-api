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

        %w[answers tags service].each do |attr|
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
    end
  end
end
