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
        let(:decorator) { AppSaveDecorator.new(app) }

        before do
          stub_request(:post, "#{astraea_url}/cases.json")
            .to_return(status: 200, body: app.to_json, headers: {})
          allow(App).to receive(:new).and_return(app)
          allow(AppSaveDecorator).to receive(:new).and_return(decorator)
        end

        it 'runs #authorize method' do
          expect(controller).to receive(:authorize).with(app)

          post :create, params: params, format: :json
        end

        it 'creates instance of AppSaveDecorator and pass the app instance to it' do
          expect(AppSaveDecorator).to receive(:new).with(app).and_return(decorator)

          post :create, params: params, format: :json
        end

        it 'runs #decorate method' do
          expect(decorator).to receive(:decorate)

          post :create, params: params, format: :json
        end

        it 'runs #save method of Apps::AppApi' do
          expect(AppApi).to receive(:save).with(decorator.app).and_call_original

          post :create, params: params, format: :json
        end

        context 'when app was created' do
          it 'respond with status 200' do
            post :create, params: params, format: :json

            expect(response.status).to eq 200
          end

          it 'respond with app data' do
            post :create, params: params, format: :json

            expect(response.body).to have_json_path('case_id')
          end
        end

        context 'when case was not created' do
          before { allow_any_instance_of(Faraday::Response).to receive(:status).and_return(422) }

          it 'respond with error status' do
            post :create, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end

      describe 'PUT #update' do
        let(:app_id) { '12345' }
        let(:app) { build(:app, case_id: app_id, without_item: true) }
        let(:params) { { case_id: app_id, app: app.as_json } }

        before do
          allow(App).to receive(:new).and_return(app)
          stub_request(:put, "#{astraea_url}/cases/#{app_id}.json")
            .to_return(status: 200, body: { message: 'updated' }.to_json, headers: {})
        end

        it 'runs #authorize method' do
          expect(controller).to receive(:authorize).with(app)

          post :update, params: params, format: :json
        end

        it 'runs #update method of Apps::AppApi' do
          expect(AppApi).to receive(:update).with(app_id, app).and_call_original

          post :update, params: params, format: :json
        end

        context 'when app_id was updated' do
          it 'respond with status 200' do
            post :update, params: params, format: :json

            expect(response.status).to eq 200
          end

          it 'respond with app data' do
            post :update, params: params, format: :json

            expect(response.body).to have_json_path('message')
          end
        end

        context 'when app_id was not updated' do
          before { allow_any_instance_of(Faraday::Response).to receive(:status).and_return(422) }

          it 'respond with error status' do
            post :update, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end

      describe 'DELETE #destroy' do
        let(:params) { { case_id: 12_345 } }

        before do
          stub_request(:delete, %r{#{astraea_url}/cases.json?})
            .to_return(status: 200, body: {}.to_json)
        end

        it 'creates instance of scope policy' do
          expect(AppApiPolicy::Scope).to receive(:new).with(subject.current_user, AppApi).and_call_original

          delete :destroy, params: params, format: :json
        end

        it 'runs #resolve method for policy instance' do
          expect_any_instance_of(AppApiPolicy::Scope).to receive(:resolve).and_call_original

          delete :destroy, params: params, format: :json
        end

        it 'respond with 200 status' do
          delete :destroy, params: params, format: :json

          expect(response.status).to eq 200
        end

        context 'when api respond with error' do
          before do
            stub_request(:delete, %r{#{astraea_url}/cases.json?})
              .to_return(status: 422, body: {}.to_json)
          end

          it 'respond with error status' do
            delete :destroy, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
