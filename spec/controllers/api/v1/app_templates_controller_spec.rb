require 'rails_helper'

module Api
  module V1
    RSpec.describe AppTemplatesController, type: :controller do
      sign_in_user

      describe 'POST #create' do
        let(:service) { create(:service) }
        let(:app_template) { create(:app_template) }
        let(:params) { { service_id: service.id, app_template: app_template.as_json } }
        before { allow(AppTemplates::Create).to receive(:call).and_return(create_dbl) }

        context 'when app_template was created' do
          let(:create_dbl) { double(:create, success?: true, app_template: app_template) }

          it 'call AppTemplates::Create#call method' do
            expect(AppTemplates::Create).to receive(:call)

            post :create, params: params, format: :json
          end

          it 'response with created ticket' do
            post :create, params: params, format: :json

            expect(parse_json(response.body)['id']).to eq app_template.id
          end

          it 'response with success status' do
            post :create, params: params, format: :json

            expect(response.status).to eq 200
          end
        end

        context 'when app_template was not created' do
          let(:create_dbl) { double(:create, success?: false, errors: { message: 'test' }) }

          it 'response with error message' do
            post :create, params: params, format: :json

            expect(response.body).to eq create_dbl.errors.to_json
          end

          it 'response with error status' do
            post :create, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
