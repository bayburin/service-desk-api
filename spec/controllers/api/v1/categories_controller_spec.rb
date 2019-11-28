require 'rails_helper'

module Api
  module V1
    RSpec.describe CategoriesController, type: :controller do
      sign_in_user

      describe 'GET #index' do
        let!(:categories) { create_list(:category, 3) }

        it 'calls :all method for CategoriesQuery instance' do
          expect_any_instance_of(CategoriesQuery).to receive(:all).and_call_original

          get :index, format: :json
        end

        it 'calls CategorySerializer' do
          expect(Categories::CategoryBaseSerializer).to receive(:new).at_least(3).and_call_original

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
        let(:policy_attributes) do
          PolicyAttributes.new(
            serializer: Categories::CategoryGuestSerializer,
            serialize: ['services', 'faq.answers.attachments']
          )
        end
        before { allow_any_instance_of(CategoryPolicy).to receive(:attributes_for_show).and_return(policy_attributes) }

        it 'loads category with specified id' do
          get :show, params: { id: category.id }, format: :json

          expect(parse_json(response.body)['id']).to eq category.id
        end

        it 'calls :attributes_for_show method from policy for loaded category' do
          expect_any_instance_of(CategoryPolicy).to receive(:attributes_for_show).and_call_original

          get :show, params: { id: category.id }, format: :json
        end

        it 'renders data with serializer specified in policy' do
          expect(policy_attributes.serializer).to receive(:new).and_call_original

          get :show, params: { id: category.id }, format: :json
        end

        it 'includes attributes specified in policy' do
          get :show, params: { id: category.id }, format: :json

          expect(response.body).to have_json_path('services')
          expect(response.body).to have_json_path('faq/0/answers/0/attachments')
        end

        it 'respond with 200 status' do
          get :show, params: { id: category.id }, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
