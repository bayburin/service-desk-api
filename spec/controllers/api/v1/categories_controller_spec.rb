require 'rails_helper'

module Api
  module V1
    RSpec.describe CategoriesController, type: :controller do
      describe 'GET #index' do
        let!(:categories) { create_list(:category, 3) }

        it 'runs :all method for CategoriesQuery instance' do
          expect_any_instance_of(CategoriesQuery).to receive_message_chain(:all, :includes)

          get :index, format: :json
        end

        it 'includes :service attribute' do
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

        before { get :show, params: { id: category.id }, format: :json }

        it 'load category with specified id' do
          expect(parse_json(response.body)['id']).to eq category.id
        end

        it 'has :answers for :faq attribute' do
          expect(response.body).to have_json_path('faq/0/answers')
        end

        it 'runs CategorySerializer' do
          expect(response.body).to eq CategorySerializer.new(category).to_json(include: [:services, faq: :answers])
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end
    end
  end
end
