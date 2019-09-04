require 'rails_helper'

module Api
  module V1
    RSpec.describe TagsController, type: :controller do
      sign_in_user

      describe 'GET #index' do
        before do
          create(:tag, name: 'test tag')
          create(:tag, name: 'another tag')
        end

        it 'respond with success status' do
          get :index, format: :json

          expect(response.status).to eq 200
        end

        it 'renders all tags' do
          get :index, format: :json

          expect(response.body).to have_json_size(Tag.count)
        end

        context 'when "search" param exists' do
          let(:params) { { search: 'test' } }

          it 'renders filtered tags' do
            get :index, params: params, format: :json

            expect(response.body).to have_json_size(1)
            expect(parse_json(response.body)[0]['name']).to eq 'test tag'
          end
        end
      end
    end
  end
end
