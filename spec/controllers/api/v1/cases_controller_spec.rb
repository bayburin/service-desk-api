require 'rails_helper'

module Api
  module V1
    RSpec.describe CasesController, type: :controller do
      let(:resource_owner) { build_stubbed(:user_iss) }
      let(:token) { double(acceptable?: true, resource_owner_id: resource_owner.tn) }
      let(:astraea_url) { 'https://astraea-ui.iss-reshetnev.ru/api' }
      before do
        allow(controller).to receive(:current_user).and_return(resource_owner)
        allow(controller).to receive(:doorkeeper_token).and_return(token)
      end

      describe 'GET #index' do
        let(:kase) { attributes_for(:case) }
        let(:astraea_response) { { cases: [kase], statuses: [], case_count: 1 } }
        let(:params) { { filters: Oj.dump(limit: 15, offset: 30, status_id: 1) } }
        before { stub_request(:get, %r{#{astraea_url}/cases.json}).to_return(status: 200, body: Oj.dump(astraea_response)) }

        it 'adds :filters attribute to request which included string with filter params' do
          get :index, params: params, format: :json

          expect(WebMock).to have_requested(:get, %r{#{astraea_url}/cases.json.*filters=#{params[:filters]}.*})
        end

        it 'creates instance of scope policy' do
          expect(CaseApiPolicy::Scope).to receive(:new).with(resource_owner, Cases::CaseApi).and_return(CaseApiPolicy::Scope.new(resource_owner, Cases::CaseApi))

          get :index, format: :json
        end

        it 'runs :resolve method for policy instance' do
          expect_any_instance_of(CaseApiPolicy::Scope).to receive_message_chain(:resolve, :query).and_return(astraea_response)

          get :index, format: :json
        end

        %w[cases statuses case_count].each do |attr|
          it "respond with :#{attr} attributes" do
            get :index, format: :json

            expect(response.body).to have_json_path(attr)
          end
        end

        it 'respond with 200 status' do
          get :index, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'POST #create' do
        let(:kase) { build(:case, without_item: true) }
        let(:params) { { case: kase.as_json } }
        let(:decorator) { CaseSaveDecorator.new(kase) }

        before do
          stub_request(:post, 'https://astraea-ui.iss-reshetnev.ru/api/cases.json').to_return(status: 200, body: Oj.dump(kase), headers: {})
          allow(Case).to receive(:new).and_return(kase)
          allow(CaseSaveDecorator).to receive(:new).and_return(decorator)
        end

        it 'runs authorize method' do
          expect(controller).to receive(:authorize).with(kase)

          post :create, params: params, format: :json
        end

        it 'creates instance of CaseSaveDecorator and pass the case instance to it' do
          expect(CaseSaveDecorator).to receive(:new).with(kase).and_return(decorator)

          post :create, params: params, format: :json
        end

        it 'runs decorate method' do
          expect(decorator).to receive(:decorate)

          post :create, params: params, format: :json
        end

        it 'runs :save method of Cases::CaseApi' do
          expect(Cases::CaseApi).to receive(:save).with(decorator.kase)

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
          before { allow(Cases::CaseApi).to receive(:save).and_return(nil) }

          it 'respond with status 422' do
            post :create, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
