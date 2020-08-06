require 'rails_helper'

module Api
  module V1
    RSpec.describe DashboardController, type: :controller do
      sign_in_user

      describe 'GET #index' do
        let(:size) { 10 }
        let!(:services) { create_list(:service, size) }
        let!(:recommendations) { create_list(:user_recommendation, size) }
        let(:params) { { without_associations: 'true' } }

        before { get :index, params: params, format: :json }

        %w[categories services user_recommendations].each do |attr|
          it "includes #{attr}" do
            expect(response.body).to have_json_path(attr)
          end
        end

        it 'loads only 9 categories' do
          expect(response.body).to have_json_size(9).at_path('categories')
        end

        it 'loads most popular services' do
          expect(response.body).to have_json_size(6).at_path('services')
        end

        it 'loads :questions association for services' do
          expect(response.body).to have_json_path('services/0/questions')
        end

        it 'loads all user_recommendation' do
          expect(response.body).to have_json_size(size).at_path('user_recommendations')
        end

        it 'does not load :service association for categories' do
          expect(response.body).not_to have_json_path('categories/0/service')
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end

      describe 'GET #search' do
        let(:params) { { search: 'abc' } }
        let(:result) { ['result'] }
        let(:search_dbl) { double(:search, result: result, categories: [], services: [], questions: []) }
        let(:tracker) { Ahoy::Tracker.new(controller: controller) }
        before do
          allow(Search::Search).to receive(:call).and_return(search_dbl)
          allow(Ahoy::Tracker).to receive(:new).and_return(tracker)
        end

        it 'call :track method for Ahoy:Tracker class' do
          expect(tracker).to receive(:track).with(Ahoy::Event::TYPES[:search_result], any_args)
          expect(tracker).to receive(:track).with(any_args)

          get :search, params: params, format: :json
        end

        it 'respond with result' do
          get :search, params: params, format: :json

          expect(response.body).to be_json_eql result
        end

        it 'respond with status 200' do
          get :search, params: params, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #deep_search' do
        let(:params) { { search: 'abc' } }
        let(:result) { ['result'] }
        let(:search_dbl) { double(:deep_search, result: result, categories: [], services: [], questions: []) }
        let(:tracker) { Ahoy::Tracker.new(controller: controller) }
        before do
          allow(Search::DeepSearch).to receive(:call).and_return(search_dbl)
          allow(Ahoy::Tracker).to receive(:new).and_return(tracker)
        end

        it 'call :track method for Ahoy:Tracker class' do
          expect(tracker).to receive(:track).with(Ahoy::Event::TYPES[:deep_search_result], any_args)
          expect(tracker).to receive(:track).with(any_args)

          get :deep_search, params: params, format: :json
        end

        it 'respond with result' do
          get :deep_search, params: params, format: :json

          expect(response.body).to be_json_eql result
        end

        it 'respond with status 200' do
          get :deep_search, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
