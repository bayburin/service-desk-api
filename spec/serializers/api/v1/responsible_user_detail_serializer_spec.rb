require 'rails_helper'

module Api
  module V1
    RSpec.describe ResponsibleUserDetailsSerializer, type: :model do
      let(:user_detail) { ResponsibleUserDetails.new({}) }
      subject { ResponsibleUserDetailsSerializer.new(user_detail).to_json }

      %w[id_tn last_name first_name middle_name full_name tn dept phone].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
