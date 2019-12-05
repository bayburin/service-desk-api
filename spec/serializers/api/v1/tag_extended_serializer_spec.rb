require 'rails_helper'

module Api
  module V1
    RSpec.describe TagExtendedSerializer, type: :model do
      let!(:tag) { create(:tag) }
      let(:custom_tag) { Tag.select('id, name, id as popularity').first }
      subject { TagExtendedSerializer.new(custom_tag).to_json }

      it 'inherits from SimpleDelegator class' do
        expect(TagExtendedSerializer).to be < TagSerializer
      end

      %w[id name popularity].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
