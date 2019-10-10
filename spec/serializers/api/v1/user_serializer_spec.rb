require 'rails_helper'

module Api
  module V1
    RSpec.describe UserSerializer, type: :model do
      let(:user) { build(:user) }
      subject { UserSerializer.new(user).to_json }

      %w[tn dept fio room tel email comment duty status datereg duty_code fio_initials category id_tn login dept_kadr ms tn_ms adLogin mail surname firstname middlename initials_family family_with_initials is_chief role_id role].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
