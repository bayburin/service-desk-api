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

      describe 'GET #popular' do
        let!(:service) { create(:service) }
        let!(:ticket) { service.tickets.first }
        let!(:first_tag) { create(:tag, name: 'main tag') }
        let!(:second_tag) { create(:tag, name: 'second tag') }
        let(:params) { { service_id: service.id } }

        before do
          service.tickets.first.tags.push(first_tag, second_tag)
          service.tickets.last.tags << second_tag
        end

        it 'respond with tags ordered by popularity' do
          get :popular, params: params, format: :json

          expect(parse_json(response.body).map { |el| el['id'] }).to eq [second_tag.id, first_tag.id]
        end

        it 'adds :popularity attribute to response' do
          get :popular, params: params, format: :json

          expect(response.body).to have_json_path('0/popularity')
        end

        it 'respond with success status' do
          get :popular, params: params, format: :json

          expect(response.status).to eq 200
        end
      end
    end
  end
end
