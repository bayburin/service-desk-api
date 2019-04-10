require 'rails_helper'

module Api
  module V1
    RSpec.describe UsersController, type: :controller do
      let(:resource_owner) { build_stubbed(:user_iss) }
      let(:token) { double(acceptable?: true, resource_owner_id: resource_owner.tn) }
      before { allow(controller).to receive(:doorkeeper_token).and_return(token) }

      describe 'GET #info' do
        before { allow_any_instance_of(Api::V1::Doorkeeper::UserInfo).to receive(:run).and_return(true) }

        it 'calls :run method for Doorkeeper::UserInfo instance' do
          expect_any_instance_of(Doorkeeper::UserInfo).to receive(:run)

          get :info, format: :json
        end

        it 'respond with 200 status' do
          get :info, format: :json

          expect(response.status).to eq 200
        end

        context 'when :run method returns false' do
          before do
            allow_any_instance_of(Api::V1::Doorkeeper::UserInfo).to receive(:run).and_return(false)
            allow_any_instance_of(Api::V1::Doorkeeper::UserInfo).to receive(:error).and_return(status: 422)
          end

          it 'respond with 422 status' do
            get :info, format: :json

            expect(response.status).to eq 422
          end
        end
      end

      describe 'GET #owns' do
        let(:user) { UserIss.find_by(id_tn: token.resource_owner_id) }
        let(:user_data) { [] }

        before do
          create_list(:service, 3, is_hidden: false)
          create_list(:service, 3, is_hidden: true)
          stub_request(:get, "#{ENV['SVT_NAME']}/user_isses/#{resource_owner.id_tn}/items")
            .to_return(body: user_data.to_json)
          get :owns, format: :json
        end

        it 'connects with http://svt.iss-reshetnev.ru to receive items' do
          expect(WebMock).to have_requested(:get, "#{ENV['SVT_NAME']}/user_isses/#{resource_owner.id_tn}/items")
        end

        it 'respond with :items and :services arrays' do
          expect(response.body).to have_json_path('services')
          expect(response.body).to have_json_path('items')
        end

        it 'loads all visible services' do
          parse_json(response.body)['services'].each do |service|
            expect(service['is_hidden']).to be_falsey
          end
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end
    end
  end
end
