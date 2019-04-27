require 'rails_helper'

module Api
  module V1
    RSpec.describe CategoriesController, type: :controller do
      describe 'GET #index' do
        let!(:categories) { create_list(:category, 3) }

        it 'runs :all method for CategoriesQuery instance' do
          expect_any_instance_of(CategoriesQuery).to receive(:all)

          get :index, format: :json
        end

        %w[id name short_description popularity icon_name services].each do |attr|
          it "has #{attr} attribute" do
            get :index, format: :json

            expect(response.body).to have_json_path("0/#{attr}")
          end
        end

        it 'respond with 200 status' do
          get :index, format: :json

          expect(response.status).to eq 200
        end
      end

      describe 'GET #show' do
        let(:category) { create(:category) }
        let!(:service_1) { create(:service, category: category) }
        let!(:tickets_1) { create_list(:ticket, 3, service: service_1) }
        let!(:service_2) { create(:service, category: category) }
        let!(:tickets_2) { create_list(:ticket, 4, service: service_2, ticket_type: :common_case) }
        let(:limit) { 3 }
        let(:by_popularity) { Ticket.where(ticket_type: :question).extend(Scope).all.by_popularity.limit(limit).pluck(:id) }

        before { get :show, params: { id: category.id }, format: :json }

        it 'load category with specified id' do
          expect(parse_json(response.body)['id']).to eq category.id
        end

        %w[id name short_description icon_name popularity services faq].each do |attr|
          it "has #{attr} attribute" do
            expect(response.body).to have_json_path(attr)
          end
        end

        it 'loads most popularity tickets to :faq attribute' do
          expect(parse_json(response.body)['faq'].map { |el| el['id'] }).to eq by_popularity
        end

        it 'limits :faq attribute' do
          expect(response.body).to have_json_size(limit).at_path('faq')
        end

        it 'loads only tickets with type :question' do
          parse_json(response.body)['faq'].each do |ticket|
            expect(ticket['ticket_type']).to eq 'question'
          end
        end

        it 'has :answers attribute into :faq' do
          expect(response.body).to have_json_path('faq/0/answers')
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end
    end
  end
end
