require 'rails_helper'

module Api
  module V1
    RSpec.describe DashboardController, type: :controller do
      describe 'GET #index' do
        let(:size) { 5 }
        let!(:services) { create_list(:service, size) }
        let(:params) { { without_associations: 'true' } }

        it 'includes services and controllers' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_path('categories')
          expect(response.body).to have_json_path('services')
        end

        it 'loads all services' do
          get :index, params: params, format: :json

          expect(response.body).to have_json_size(size).at_path('categories')
          expect(response.body).to have_json_size(size).at_path('services')
        end

        it 'respond with 200 status' do
          get :index, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
