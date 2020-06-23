require 'rails_helper'

module Api
  module V1
    RSpec.describe UsersController, type: :controller do
      sign_in_user

      describe 'GET #info' do
        it 'calls UserSerializer' do
          expect(UserSerializer).to receive(:new).and_call_original

          get :info, format: :json
        end

        it 'respond with 200 status' do
          get :info, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #owns' do
        before do
          create_list(:service, 3, is_hidden: false)
          create_list(:service, 3, is_hidden: true)
          stub_request(:get, "#{ENV['SVT_URL']}/user_isses/#{subject.current_user.id_tn}/items").to_return(body: '')
        end

        it 'calls Svt::SvtApi#items method to receive :items' do
          expect(SvtApi).to receive(:items).with(subject.current_user).and_call_original

          get :owns, format: :json
        end

        %w[items services].each do |attr|
          it "respond with #{attr} arrays" do
            get :owns, format: :json

            expect(response.body).to have_json_path(attr)
          end
        end

        it 'runs :allowed_to_create_app method for ServiceQuery query' do
          expect_any_instance_of(ServicesQuery).to receive(:allowed_to_create_app).and_call_original

          get :owns, format: :json
        end

        it 'respond with 200 status' do
          get :owns, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #notifications' do
        let!(:notifications) { create_list(:notification, 6, tn: subject.current_user.tn) }
        let(:params) { { limit: '5' } }
        let(:query) { NotificationsQuery.new(subject.current_user) }
        before { allow(NotificationsQuery).to receive(:new).with(subject.current_user).and_return(query) }

        it 'creates instance of UserDecorator' do
          expect(UserDecorator).to receive(:new).with(subject.current_user).and_call_original

          get :notifications, params: params, format: :json
        end

        it 'runs #read_notifications method for UserDecorator' do
          expect_any_instance_of(UserDecorator).to receive(:read_notifications)

          get :notifications, params: params, format: :json
        end

        it 'creates instance of NotificationsQuery class' do
          expect(NotificationsQuery).to receive(:new).with(subject.current_user)

          get :notifications, params: params, format: :json
        end

        it 'runs #last_notifications for NotificationsQuery instance' do
          expect(query).to receive(:last_notifications).with(params[:limit]).and_call_original

          get :notifications, params: params, format: :json
        end

        it 'respond with notifications' do
          get :notifications, params: params, format: :json

          expect(response.body).to have_json_size(params[:limit].to_i)
        end

        it 'respond with 200 status' do
          get :notifications, params: params, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #new_notifications' do
        let!(:notifications) { create_list(:notification, 6, tn: subject.current_user.tn) }
        let(:params) { { limit: '5' } }
        let(:query) { NotificationsQuery.new(subject.current_user) }
        before { allow(NotificationsQuery).to receive(:new).with(subject.current_user).and_return(query) }

        it 'creates instance of UserDecorator' do
          expect(UserDecorator).to receive(:new).with(subject.current_user).and_call_original

          get :new_notifications, params: params, format: :json
        end

        it 'runs #read_notifications method for UserDecorator' do
          expect_any_instance_of(UserDecorator).to receive(:read_notifications).and_call_original

          get :new_notifications, params: params, format: :json
        end

        context 'when limit is set' do
          it 'respond with limited notifications' do
            get :new_notifications, params: params, format: :json

            expect(response.body).to have_json_size(params[:limit].to_i)
          end
        end

        context 'when limit is not set' do
          let(:params) { {} }

          it 'respond with all notifications' do
            get :new_notifications, params: params, format: :json

            expect(response.body).to have_json_size(notifications.size)
          end
        end

        it 'respond with 200 status' do
          get :new_notifications, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
