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

        it 'runs :allowed_to_create_case method for ServiceQuery query' do
          expect_any_instance_of(ServicesQuery).to receive(:allowed_to_create_case).and_call_original

          get :owns, format: :json
        end

        it 'respond with 200 status' do
          get :owns, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #notifications' do
        let!(:notifications) { create_list(:notification, 6, tn: subject.current_user.tn) }

        it 'runs #notifications method for current_user' do
          expect(subject.current_user).to receive(:notifications).and_call_original

          get :notifications, format: :json
        end

        it 'orders notifications' do
          get :notifications, format: :json

          expect(parse_json(response.body).map { |el| el['id'] }).to eq notifications.pluck(:id).reverse
        end

        context 'with limit parameter' do
          it 'returns required number of notifications' do
            get :notifications, params: { limit: 5 }, format: :json

            expect(response.body).to have_json_size(5)
          end
        end

        context 'without limit parameter' do
          it 'returns all notifications belongs to user' do
            get :notifications, format: :json

            expect(response.body).to have_json_size(6)
          end
        end
      end
    end
  end
end
