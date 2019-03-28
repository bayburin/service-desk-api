require 'rails_helper'

module Api
  module V1
    RSpec.describe AnswersController, type: :controller do
      describe 'GET #index' do
        let(:ticket) { create(:ticket) }
        let!(:answers) { create_list(:answer, 3, ticket: ticket) }
        let(:params) { { ticket_id: ticket.id } }

        it 'loads all answers' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_size(3)
        end

        %w[id ticket_id reason answer link ticket].each do |attr|
          it "has #{attr} attribute" do
            get :index, params: params, format: :json

            expect(response.body).to have_json_path("0/#{attr}")
          end
        end

        it 'includes :category attribute into service' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_path('0/ticket/service/category')
        end

        it 'respond with 200 status' do
          get :index, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
