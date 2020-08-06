require 'rails_helper'

module Api
  module V1
    RSpec.describe AppsController, type: :controller do
      sign_in_user

      let(:astraea_url) { ENV['ASTRAEA_URL'] }
      before { allow(subject).to receive(:authorize).and_return(true) }

      describe 'GET #index' do
        let(:app) { attributes_for(:app) }
        let(:astraea_response) { { cases: [app], statuses: [] } }
        let(:filters) { { limit: 15, offset: 30, status_id: 1 } }
        let(:params) { { filters: filters.to_json } }
        before do
          stub_request(:get, %r{#{astraea_url}/cases.json})
            .to_return(status: 200, body: astraea_response.to_json)
        end

        it 'adds :filters attribute to request which included string with filter params' do
          get :index, params: params, format: :json

          expect(WebMock).to have_requested(:get, %r{#{astraea_url}/cases.json.*filters=#{params[:filters]}.*})
        end

        it 'creates instance of scope policy' do
          expect(AppApiPolicy::Scope).to receive(:new).with(subject.current_user, AppApi).and_call_original

          get :index, format: :json
        end

        it 'runs #resolve method for policy instance' do
          expect_any_instance_of(AppApiPolicy::Scope).to receive(:resolve).and_call_original

          get :index, format: :json
        end

        %w[apps statuses].each do |attr|
          it "respond with :#{attr} attributes" do
            get :index, format: :json

            expect(response.body).to have_json_path(attr)
          end
        end

        it 'respond with 200 status' do
          get :index, format: :json

          expect(response.status).to eq 200
        end

        context 'when api respond with error' do
          before do
            stub_request(:get, %r{#{astraea_url}/cases.json})
              .to_return(status: 422, body: astraea_response.to_json)
          end

          it 'respond with error status' do
            get :index, format: :json

            expect(response.status).to eq 422
          end
        end
      end

      describe 'POST #create' do
        let(:app) { build(:app, without_item: true) }
        let(:params) { { app: app.as_json } }
        let(:decorator_dbl) { double(:decorator, decorate: true, app: app) }
        let(:body) { { app_id: 1, foo: 'bar' } }
        let(:status) { 200 }
        let(:response_dbl) { double(:response, body: body, status: status) }
        before do
          allow(App).to receive(:new).and_return(app)
          allow(AppSaveDecorator).to receive(:new).and_return(decorator_dbl)
          allow(AppApi).to receive(:save).and_return(response_dbl)
        end

        it 'call #authorize method' do
          expect(controller).to receive(:authorize).with(app)

          post :create, params: params, format: :json
        end

        it 'create instance of AppSaveDecorator and pass the app instance to it' do
          expect(AppSaveDecorator).to receive(:new).with(app).and_return(decorator_dbl)

          post :create, params: params, format: :json
        end

        it 'call #decorate method' do
          expect(decorator_dbl).to receive(:decorate)

          post :create, params: params, format: :json
        end

        it 'call #save method of Apps::AppApi' do
          expect(AppApi).to receive(:save).with(decorator_dbl.app)

          post :create, params: params, format: :json
        end

        it 'respond with received status' do
          post :create, params: params, format: :json

          expect(response.status).to eq status
        end

        it 'respond with app data' do
          post :create, params: params, format: :json

          expect(response.body).to eq body.to_json
        end
      end

      describe 'PUT #update' do
        let(:app_id) { '12345' }
        let(:app) { build(:app, case_id: app_id, without_item: true) }
        let(:params) { { case_id: app_id, app: app.as_json } }
        let(:body) { { app_id: 1, foo: 'bar' } }
        let(:status) { 200 }
        let(:response_dbl) { double(:response, body: body, status: status) }

        before do
          allow(App).to receive(:new).and_return(app)
          allow(AppApi).to receive(:update).and_return(response_dbl)
        end

        it 'call #authorize method' do
          expect(controller).to receive(:authorize).with(app)

          post :update, params: params, format: :json
        end

        it 'call #update method of Apps::AppApi' do
          expect(AppApi).to receive(:update).with(app_id, app)

          post :update, params: params, format: :json
        end

        it 'respond with received status' do
          post :update, params: params, format: :json

          expect(response.status).to eq 200
        end

        it 'respond with app data' do
          post :update, params: params, format: :json

          expect(response.body).to eq body.to_json
        end
      end

      describe 'DELETE #destroy' do
        let(:params) { { case_id: 12_345 } }
        let(:body) { { app_id: 1, foo: 'bar' } }
        let(:status) { 200 }
        let(:response_dbl) { double(:response, body: body, status: status) }

        before do
          allow_any_instance_of(AppApi).to receive(:destroy).and_return(response_dbl)
        end

        it 'creates instance of scope policy' do
          expect(AppApiPolicy::Scope).to receive(:new).with(subject.current_user, AppApi).and_call_original

          delete :destroy, params: params, format: :json
        end

        it 'call #resolve method for policy instance' do
          expect_any_instance_of(AppApiPolicy::Scope).to receive(:resolve).and_call_original

          delete :destroy, params: params, format: :json
        end

        it 'respond with received status' do
          delete :destroy, params: params, format: :json

          expect(response.status).to eq status
        end

        it 'respond with app data' do
          delete :destroy, params: params, format: :json

          expect(response.body).to eq body.to_json
        end
      end
    end
  end
end
