require 'rails_helper'

module Api
  module V1
    RSpec.describe UsersController, type: :controller do
      sign_in_user

      describe 'GET #info' do
        before { get :info, format: :json }

        it 'runs UserSerializer' do
          expect(response.body).to eq UserSerializer.new(subject.current_user).to_json
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end

      describe 'GET #owns' do
        before do
          create_list(:service, 3, is_hidden: false)
          create_list(:service, 3, is_hidden: true)
          stub_request(:get, "#{ENV['SVT_URL']}/user_isses/#{subject.current_user.id_tn}/items").to_return(body: '')
        end

        it 'runs Svt::SvtApi#items method to receive :items' do
          expect(SvtApi).to receive(:items).with(subject.current_user).and_call_original

          get :owns, format: :json
        end

        %w[items services].each do |attr|
          it "respond with #{attr} arrays" do
            get :owns, format: :json

            expect(response.body).to have_json_path(attr)
          end
        end

        it 'loads all visible services' do
          get :owns, format: :json

          parse_json(response.body)['services'].each do |service|
            expect(service['is_hidden']).to be_falsey
          end
        end

        it 'respond with 200 status' do
          get :owns, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
