require 'rails_helper'

module Api
  module V1
    RSpec.describe UserRecommendationSerializer, type: :model do
      let(:recommendation) { build(:user_recommendation) }
      subject { UserRecommendationSerializer.new(recommendation).to_json }

      %w[id title external link query_params order].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
