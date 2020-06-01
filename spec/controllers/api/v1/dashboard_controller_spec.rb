require 'rails_helper'

module Api
  module V1
    RSpec.describe DashboardController, type: :controller do
      sign_in_user

      describe 'GET #index' do
        let(:size) { 10 }
        let!(:services) { create_list(:service, size) }
        let!(:recommendations) { create_list(:user_recommendation, size) }
        let(:params) { { without_associations: 'true' } }

        before { get :index, params: params, format: :json }

        %w[categories services user_recommendations].each do |attr|
          it "includes #{attr}" do
            expect(response.body).to have_json_path(attr)
          end
        end

        it 'loads only 9 categories' do
          expect(response.body).to have_json_size(9).at_path('categories')
        end

        it 'loads most popular services' do
          expect(response.body).to have_json_size(6).at_path('services')
        end

        it 'loads :questions association for services' do
          expect(response.body).to have_json_path('services/0/questions')
        end

        it 'loads all user_recommendation' do
          expect(response.body).to have_json_size(size).at_path('user_recommendations')
        end

        it 'does not load :service association for categories' do
          expect(response.body).not_to have_json_path('categories/0/service')
        end

        it 'respond with 200 status' do
          expect(response.status).to eq 200
        end
      end

      describe 'GET #search' do
        let(:term) { 'abc' }
        let(:params) { { search: term } }
        let(:tracker) { Ahoy::Tracker.new(controller: controller) }

        before { allow(Ahoy::Tracker).to receive(:new).and_return(tracker) }

        context 'with stubbed sphinx' do
          before do
            allow(Category).to receive(:search).and_return([])
            allow(Service).to receive(:search).and_return([])
            allow(Ticket).to receive(:search).and_return([])
          end

          it 'runs :track method for Ahoy:Tracker class' do
            expect(tracker).to receive(:track).with('Search', params[:search])
            expect(tracker).to receive(:track).with(any_args)

            get :search, params: params, format: :json
          end

          it 'respond with status 200' do
            get :search, params: params, format: :json

            expect(response.status).to eq 200
          end
        end

        context 'when database has any data' do
          let!(:categories) { create_list(:category, 2) }
          let!(:categories_abc) { create_list(:category, 3, name: term) }
          let!(:services_abc) { create_list(:service, 3, name: term) }
          let!(:questions_abc) { create_list(:question, 3, name: term) }

          before do
            ThinkingSphinx::Test.init
            ThinkingSphinx::Test.start_with_autostop
            sleep 1

            get :search, params: params, format: :json
          end

          # after { ThinkingSphinx::Test.stop }

          it 'respond with finded data', transactional: true do
            expect(response.body).to have_json_size(9)
          end

          it 'respond with array which contains categories at first, then services and then tickets', transactional: true do
            (0..2).each { |i| expect(response.body).to have_json_path("#{i}/icon_name") }
            (3..5).each { |i| expect(response.body).to have_json_path("#{i}/category_id") }
            (6..8).each { |i| expect(response.body).to have_json_path("#{i}/ticket") }
          end

          it 'sortings each group of data (separate sorting inside categories, inside services and inside tickets) by popularity', transactional: true do
            expect(parse_json(response.body).first(3).map { |data| data['popularity'] }).to eq categories_abc.pluck(:popularity).sort { |a, b| b <=> a }
            expect(parse_json(response.body).first(6).last(3).map { |data| data['popularity'] }).to eq services_abc.pluck(:popularity).sort { |a, b| b <=> a }
            expect(parse_json(response.body).last(3).map { |data| data['popularity'] }).to eq questions_abc.pluck(:popularity).sort { |a, b| b <=> a }
          end

          it 'adds :service attribute to the :ticket attribute', transactional: true do
            (6..8).each { |i| expect(response.body).to have_json_path("#{i}/ticket/service") }
          end
        end
      end

      describe 'GET #deep_search' do
        let(:term) { 'abc' }
        let(:params) { { search: term } }
        let(:tracker) { Ahoy::Tracker.new(controller: controller) }

        before { allow(Ahoy::Tracker).to receive(:new).and_return(tracker) }

        context 'with stubbed sphinx' do
          before do
            allow(Category).to receive(:search).and_return([])
            allow(Service).to receive(:search).and_return([])
            allow(Ticket).to receive(:search).and_return([])
          end

          it 'runs :track method for Ahoy:Tracker class' do
            expect(tracker).to receive(:track).with('Deep search', params[:search])
            expect(tracker).to receive(:track).with(any_args)

            get :deep_search, params: params, format: :json
          end

          it 'respond with status 200' do
            get :deep_search, params: params, format: :json

            expect(response.status).to eq 200
          end
        end

        context 'with data' do
          let!(:categories) { create_list(:category, 2) }
          let!(:categories_abc) { create_list(:category, 3, name: term) }
          let!(:services_abc) { create_list(:service, 3, name: term) }
          let!(:questions_abc) { create_list(:question, 3, name: term) }

          before do
            ThinkingSphinx::Test.init
            ThinkingSphinx::Test.start_with_autostop
            sleep 1

            get :deep_search, params: params, format: :json
          end

          # after { ThinkingSphinx::Test.stop }

          it 'respond with finded data', transactional: true do
            expect(response.body).to have_json_size(9)
          end

          it 'respond with array which contains categories at first, then services and then tickets', transactional: true do
            (0..2).each { |i| expect(response.body).to have_json_path("#{i}/icon_name") }
            (3..5).each { |i| expect(response.body).to have_json_path("#{i}/category_id") }
            (6..8).each { |i| expect(response.body).to have_json_path("#{i}/ticket") }
          end

          it 'sort each group of data (separate sorting inside categories, inside services and inside tickets) by popularity', transactional: true do
            expect(parse_json(response.body).first(3).map { |data| data['popularity'] }).to eq categories_abc.pluck(:popularity).sort { |a, b| b <=> a }
            expect(parse_json(response.body).first(6).last(3).map { |data| data['popularity'] }).to eq services_abc.pluck(:popularity).sort { |a, b| b <=> a }
            expect(parse_json(response.body).last(3).map { |data| data['popularity'] }).to eq questions_abc.pluck(:popularity).sort { |a, b| b <=> a }
          end

          it 'add :service attribute to the :ticket attribute', transactional: true do
            (6..8).each { |i| expect(response.body).to have_json_path("#{i}/ticket/service") }
          end

          # it 'adds :attachments attribute to the :answer attribute', transactional: true do
          #   (6..8).each { |i| expect(response.body).to have_json_path("#{i}/answers/0/attachments") }
          # end
        end
      end
    end
  end
end
