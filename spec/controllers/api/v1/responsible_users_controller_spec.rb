require 'rails_helper'

module Api
  module V1
    RSpec.describe ResponsibleUsersController, type: :controller do
      sign_in_user

      let(:params) { { tns: JSON.generate([1, 2, 3]) } }
      let(:result) { { data: [{}, {}, {}] }.as_json }
      before { allow_any_instance_of(Employees::Employee).to receive(:load_users).and_return(result) }

      describe 'GET #index' do
        it 'creates instance of Employees::Employee' do
          expect(Employees::Employee).to receive(:new).with(:exact).and_call_original

          get :index, params: params, format: :json
        end

        it 'calls #load_users method for Employees::Employee instance' do
          expect_any_instance_of(Employees::Employee).to receive(:load_users).and_return(result)

          get :index, params: params, format: :json
        end

        it 'respond with UserDetails serializer called' do
          expect(UserDetailsSerializer).to receive(:new).exactly(result['data'].length).times.and_call_original

          get :index, params: params, format: :json
        end

        it 'respond with 200 status' do
          get :index, params: params, format: :json

          expect(response.status).to eq 200
        end

        context 'when array of params is empty' do
          let(:params) { { tns: JSON.generate([]) } }

          it 'does not call #load_users method for Employees::Employee instance' do
            expect_any_instance_of(Employees::Employee).not_to receive(:load_users)

            get :index, params: params, format: :json
          end
        end
      end

      describe 'GET #search' do
        it 'creates instance of Employees::Employee' do
          expect(Employees::Employee).to receive(:new).with(:like).and_call_original

          get :search, params: params, format: :json
        end

        it 'calls #load_users method for Employees::Employee instance' do
          expect_any_instance_of(Employees::Employee).to receive(:load_users).and_return(result)

          get :search, params: params, format: :json
        end

        it 'respond with UserDetails serializer called' do
          expect(UserDetailsSerializer).to receive(:new).exactly(result['data'].length).times.and_call_original

          get :search, params: params, format: :json
        end

        it 'respond with 200 status' do
          get :search, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
