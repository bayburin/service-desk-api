require 'rails_helper'

module Api
  module V1
    RSpec.describe BaseController, type: :controller do
      sign_in_user

      describe 'GET #welcome' do
        it 'renders nothing' do
          get :welcome

          expect(response.body).to be_blank
        end
      end
    end
  end
end
