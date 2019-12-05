require 'rails_helper'

module Api
  module V1
    RSpec.describe CasesController, type: :controller do
      sign_in_user

      let(:astraea_url) { 'https://astraea-ui.iss-reshetnev.ru/api' }

      describe 'GET #index' do
        let(:kase) { attributes_for(:case) }
        let(:astraea_response) { { cases: [kase], statuses: [] } }
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
          expect(CaseApiPolicy::Scope).to receive(:new).with(subject.current_user, CaseApi).and_call_original

          get :index, format: :json
        end

        it 'runs #resolve method for policy instance' do
          expect_any_instance_of(CaseApiPolicy::Scope).to receive(:resolve).and_call_original

          get :index, format: :json
        end

        %w[cases statuses].each do |attr|
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
        let(:kase) { build(:case, without_item: true) }
        let(:params) { { case: kase.as_json } }
        let(:decorator) { CaseSaveDecorator.new(kase) }

        before do
          stub_request(:post, 'https://astraea-ui.iss-reshetnev.ru/api/cases.json')
            .to_return(status: 200, body: kase.to_json, headers: {})
          allow(Case).to receive(:new).and_return(kase)
          allow(CaseSaveDecorator).to receive(:new).and_return(decorator)
        end

        it 'runs #authorize method' do
          expect(controller).to receive(:authorize).with(kase)

          post :create, params: params, format: :json
        end

        it 'creates instance of CaseSaveDecorator and pass the case instance to it' do
          expect(CaseSaveDecorator).to receive(:new).with(kase).and_return(decorator)

          post :create, params: params, format: :json
        end

        it 'runs #decorate method' do
          expect(decorator).to receive(:decorate)

          post :create, params: params, format: :json
        end

        it 'runs #save method of Cases::CaseApi' do
          expect(CaseApi).to receive(:save).with(decorator.kase).and_call_original

          post :create, params: params, format: :json
        end

        context 'when case was created' do
          it 'respond with status 200' do
            post :create, params: params, format: :json

            expect(response.status).to eq 200
          end

          it 'respond with kase data' do
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
        let(:case_id) { '12345' }
        let(:kase) { build(:case, case_id: case_id, without_item: true) }
        let(:params) { { case_id: case_id, case: kase.as_json } }

        before do
          allow(Case).to receive(:new).and_return(kase)
          stub_request(:put, "https://astraea-ui.iss-reshetnev.ru/api/cases/#{case_id}.json")
            .to_return(status: 200, body: { message: 'updated' }.to_json, headers: {})
        end

        it 'runs #authorize method' do
          expect(controller).to receive(:authorize).with(kase)

          post :update, params: params, format: :json
        end

        it 'runs #update method of Cases::CaseApi' do
          expect(CaseApi).to receive(:update).with(case_id, kase).and_call_original

          post :update, params: params, format: :json
        end

        context 'when case was updated' do
          it 'respond with status 200' do
            post :update, params: params, format: :json

            expect(response.status).to eq 200
          end

          it 'respond with kase data' do
            post :update, params: params, format: :json

            expect(response.body).to have_json_path('message')
          end
        end

        context 'when case was not updated' do
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
          expect(CaseApiPolicy::Scope).to receive(:new).with(subject.current_user, CaseApi).and_call_original

          delete :destroy, params: params, format: :json
        end

        it 'runs #resolve method for policy instance' do
          expect_any_instance_of(CaseApiPolicy::Scope).to receive(:resolve).and_call_original

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
