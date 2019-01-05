require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:token) { double(acceptable?: true) }
  before { allow(controller).to receive(:doorkeeper_token).and_return(token) }

  describe 'GET #info' do
    before { allow_any_instance_of(Doorkeeper::UserInfo).to receive(:run).and_return(true) }

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
        allow_any_instance_of(Doorkeeper::UserInfo).to receive(:run).and_return(false)
        allow_any_instance_of(Doorkeeper::UserInfo).to receive(:error).and_return(status: 422)
      end

      it 'respond with 422 status' do
        get :info, format: :json

        expect(response.status).to eq 422
      end
    end
  end
end
