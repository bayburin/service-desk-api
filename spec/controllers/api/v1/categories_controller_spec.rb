require 'rails_helper'

module Api
  module V1
    RSpec.describe CategoriesController, type: :controller do
      describe 'GET #index' do
        let!(:categories) { create_list(:category, 3) }

        it 'loads all categories' do
          get :index, format: :json

          expect(response.body).to have_json_size(3)
        end

        %w[id name short_description popularity services].each do |attr|
          it "has #{attr} attribute" do
            get :index, format: :json

            expect(response.body).to have_json_path("0/#{attr}")
          end
        end

        it 'respond with 200 status' do
          get :index, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
