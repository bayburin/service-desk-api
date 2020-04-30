require 'rails_helper'

module Api
  module V2
    RSpec.describe BaseController, type: :controller do
      sign_in_guest_user

      describe 'GET #welcome' do
        let(:message) { { message: 'v2' } }

        it 'renders nothing' do
          get :welcome

          expect(response.body).to eq message.to_json
        end
      end
    end
  end
end
