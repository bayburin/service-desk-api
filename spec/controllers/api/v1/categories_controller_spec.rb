require 'rails_helper'

module Api
  module V1
    RSpec.describe CategoriesController, type: :controller do
      sign_in_user

      describe 'GET #index' do
        let!(:categories) { create_list(:category, 3) }

        it 'runs :all method for CategoriesQuery instance' do
          expect_any_instance_of(CategoriesQuery).to receive_message_chain(:all, :includes)

          get :index, format: :json
        end

        it 'runs CategorySerializer' do
          expect(CategorySerializer).to receive(:new).at_least(3).and_call_original

          get :index, format: :json
        end

        it 'has :service attribute' do
          get :index, format: :json

          expect(response.body).to have_json_path('0/services')
        end

        it 'respond with 200 status' do
          get :index, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #show' do
        let(:category) { create(:category) }
        let(:service) { create(:service, category: category) }
        let!(:tickets) { create_list(:ticket, 3, service: service) }

        it 'load category with specified id' do
          get :show, params: { id: category.id }, format: :json

          expect(parse_json(response.body)['id']).to eq category.id
        end

        it 'has :services attribute' do
          get :show, params: { id: category.id }, format: :json

          expect(response.body).to have_json_path('services')
        end

        it 'has :answers for :faq attribute' do
          get :show, params: { id: category.id }, format: :json

          expect(response.body).to have_json_path('faq/0/answers')
        end

        it 'runs CategorySerializer' do
          expect(CategorySerializer).to receive(:new).and_call_original

          get :show, params: { id: category.id }, format: :json
        end

        it 'respond with 200 status' do
          get :show, params: { id: category.id }, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
