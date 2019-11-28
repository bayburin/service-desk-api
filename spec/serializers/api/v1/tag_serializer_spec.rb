require 'rails_helper'

module Api
  module V1
    RSpec.describe TagSerializer, type: :model do
      let(:tag) { create(:tag) }
      subject { TagSerializer.new(tag).to_json }

      %w[id name].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
