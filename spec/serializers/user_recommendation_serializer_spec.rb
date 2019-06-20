require 'rails_helper'

RSpec.describe UserRecommendationSerializer, type: :model do
  let(:recommendation) { build(:user_recommendation) }
  subject { UserRecommendationSerializer.new(recommendation).to_json }

  %w[id title link order].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
