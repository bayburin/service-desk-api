require 'rails_helper'

module Api
  module V1
    RSpec.describe DashboardController, type: :controller do
      describe 'GET #index' do
        let(:size) { 5 }
        let!(:services) { create_list(:service, size) }
        let(:params) { { without_associations: 'true' } }

        before { get :index, params: params, format: :json }

        it 'includes services and controllers' do
          expect(response.body).to have_json_path('categories')
          expect(response.body).to have_json_path('services')
        end

        it 'loads all categories and services' do
          expect(response.body).to have_json_size(size).at_path('categories')
          expect(response.body).to have_json_size(size).at_path('services')
        end

        it 'loads :tickets association for services' do
          expect(response.body).to have_json_path('services/0/tickets')
        end

        it 'does not load :service association for categories' do
          expect(response.body).not_to have_json_path('categories/0/service')
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end
    end
  end
end
