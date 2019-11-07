require 'rails_helper'

module Api
  module V1
    RSpec.describe ServicesController, type: :controller do
      sign_in_user

      describe 'GET #index' do
        let(:policy_attributes) { ServicePolicy.new(User.last, Service).attributes_for_index }
        before { create_list(:service, 2) }

        it 'loads all services' do
          get :index, format: :json

          expect(response.body).to have_json_size(2)
        end

        it 'has :answers attribute for :tickets attribute' do
          get :index, format: :json

          expect(response.body).to have_json_path('0/tickets/0/answers')
        end

        it 'has :attachments attribute for :answers attribute' do
          get :index, format: :json

          expect(response.body).to have_json_path('0/tickets/0/answers/0/attachments')
        end

        it 'has :category attribute' do
          get :index, format: :json

          expect(response.body).to have_json_path('0/category')
        end

        it 'calls serializer specified in policy' do
          expect(policy_attributes.serializer).to receive(:new).at_least(2).and_call_original

          get :index, format: :json
        end

        it 'respond with 200 status' do
          get :index, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #show' do
        let(:services) { create_list(:service, 2, category: create(:category)) }
        let!(:service) { services.first }
        let(:params) { { category_id: service.category.id, id: service.id } }
        let(:policy_attributes) { ServicePolicy.new(User.last, service).attributes_for_index }
        before { service.tickets.each { |t| t.correction = create(:ticket, state: :draft) } }

        it 'loads service with specified service_id' do
          get :show, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq service.id
        end

        it 'calls :authorize method for loaded service' do
          expect(subject).to receive(:authorize).with(service).and_call_original

          get :show, params: params, format: :json
        end

        it 'calls :attributes_for_show method from policy for loaded category' do
          expect_any_instance_of(ServicePolicy).to receive(:attributes_for_show).and_call_original

          get :show, params: params, format: :json
        end

        it 'renders data with serializer specified in policy' do
          expect(policy_attributes.serializer).to receive(:new).and_call_original

          get :show, params: params, format: :json
        end

        it 'includes attributes specified in policy' do
          get :show, params: params, format: :json

          expect(response.body).to have_json_path('tickets')
        end

        it 'respond with 200 status' do
          get :show, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
