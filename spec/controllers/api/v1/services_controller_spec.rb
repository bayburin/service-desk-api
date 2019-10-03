require 'rails_helper'

module Api
  module V1
    RSpec.describe ServicesController, type: :controller do
      sign_in_user

      describe 'GET #index' do
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

        it 'runs ServiceSerializer' do
          expect(ServiceSerializer).to receive(:new).at_least(2).and_call_original

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
        before { service.tickets.each { |t| t.correction = create(:ticket, state: :draft) } }

        it 'loads service with specified service_id' do
          get :show, params: params, format: :json

          expect(parse_json(response.body)['id']).to eq service.id
        end

        context 'when user responsible for the service' do
          before do
            subject.current_user.role = create(:service_responsible)
            subject.current_user.services << service
          end

          %w[category responsible_users].each do |attr|
            it "has :#{attr} attribute" do
              get :show, params: params, format: :json

              expect(response.body).to have_json_path(attr)
            end
          end

          %w[service answers/0/attachments responsible_users tags].each do |attr|
            it "has :#{attr} attribute for :tickets attribute" do
              get :show, params: params, format: :json

              expect(response.body).to have_json_path("tickets/0/#{attr}")
            end
          end

          %w[service answers/0/attachments responsible_users tags].each do |attr|
            it "has :#{attr} attribute for :correction attribute" do
              get :show, params: params, format: :json

              expect(response.body).to have_json_path("tickets/0/correction/#{attr}")
            end
          end
        end

        context 'when user not responsible for the service ' do
          %w[category tickets/0/answers/0/attachments].each do |attr|
            it "has :#{attr} attribute" do
              get :show, params: params, format: :json

              expect(response.body).to have_json_path(attr)
            end
          end

          %w[responsible_users tickets/0/correction tickets/0/tags tickets/0/responsible_users].each do |attr|
            it "does not have :#{attr} attribute" do
              get :show, params: params, format: :json

              expect(response.body).not_to have_json_path(attr)
            end
          end
        end

        it 'runs ServiceSerializer' do
          expect(ServiceSerializer).to receive(:new).and_call_original

          get :show, params: params, format: :json
        end

        it 'respond with 200 status' do
          get :show, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
