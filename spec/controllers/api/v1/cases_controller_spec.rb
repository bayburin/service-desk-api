require 'rails_helper'

module Api
  module V1
    RSpec.describe CasesController, type: :controller do
      let(:resource_owner) { build_stubbed(:user_iss) }
      let(:token) { double(acceptable?: true, resource_owner_id: resource_owner.tn) }
      before do
        allow(controller).to receive(:doorkeeper_token).and_return(token)
        stub_request(:post, 'https://astraea-ui.iss-reshetnev.ru/api/cases.json').to_return(status: 200, body: '', headers: {})
      end

      describe 'POST #create' do
        let(:kase) { build(:case, without_item: true) }
        let(:params) { { case: kase.as_json } }
        let(:proxy) { CaseSaveProxy.new(kase) }

        it 'initialize CaseSaveProxy class with Case param' do
          expect(CaseSaveProxy).to receive(:new).with(kase).and_return(proxy)

          post :create, params: params, format: :json
        end

        it 'create a case' do
          allow(CaseSaveProxy).to receive(:new).with(kase).and_return(proxy)
          expect(proxy).to receive(:save)

          post :create, params: params, format: :json
        end

        context 'when case was created' do
          before do
            allow(CaseSaveProxy).to receive(:new).with(kase).and_return(proxy)
            allow(proxy).to receive(:save).and_return(true)
          end

          it 'respond_with 200 status' do
            post :create, params: params, format: :json

            expect(response.status).to eq 200
          end
        end

        context 'when case was not created' do
          before do
            allow(CaseSaveProxy).to receive(:new).with(kase).and_return(proxy)
            allow(proxy).to receive(:save).and_return(false)
          end

          it 'respond_with 422 status' do
            post :create, params: params, format: :json

            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
