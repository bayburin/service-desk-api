require 'rails_helper'

module Api
  module V1
    RSpec.describe BaseController, type: :controller do
      sign_in_user

      describe 'GET #welcome' do
        let(:message) { { message: 'v1' } }

        it 'renders nothing' do
          get :welcome

          expect(response.body).to eq message.to_json
        end
      end
    end
  end
end
