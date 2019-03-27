require 'rails_helper'

module Api
  module V1
    RSpec.describe ServicesController, type: :controller do
      describe 'GET #index' do
        let(:category) { create(:category) }
        let!(:services) { create_list(:service, 3, category: category) }
        let(:params) { { category_id: category.id } }

        before do
          create_list(:service, 3)
        end

        it 'loads all services with specified category_id' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_size(category.services.count)
          parse_json(response.body).each do |s|
            expect(s['category_id']).to eq category.id
          end
        end

        %w[id category_id name short_description popularity tickets].each do |attr|
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
        it 'loads all tickets with specified service_id'
        it 'has attributes'
        it 'respond with 200 status'
      end
    end
  end
end
