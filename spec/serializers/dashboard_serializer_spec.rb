require 'rails_helper'

RSpec.describe DashboardSerializer, type: :model do
  let(:categories) { create_list(:category, 3, without_associations: true) }
  let(:services) { create_list(:service, 5, without_associations: true) }
  let(:recommendations) { create_list(:user_recommendation, 5) }
  let(:category_attributes) { Oj.load(CategorySerializer.new(categories.first).to_json) }
  let(:service_attributes) { Oj.load(ServiceSerializer.new(services.first).to_json) }
  let(:recommendations_attributes) { Oj.load(UserRecommendationSerializer.new(recommendations.first).to_json) }
  let(:dashboard) { Dashboard.new(categories, services, recommendations) }
  subject { DashboardSerializer.new(dashboard).to_json }

  %w[categories services user_recommendations].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  it 'runs CategorySerializer for :services attribute' do
    expect(Oj.load(subject)['categories'][0]).to eq category_attributes
  end

  it 'runs ServiceSerializer for :services attribute' do
    expect(Oj.load(subject)['services'][0]).to eq service_attributes
  end

  it 'runs UserRecommendationSerializer for :user_recommendations attribute' do
    expect(Oj.load(subject)['user_recommendations'][0]).to eq recommendations_attributes
  end
end
