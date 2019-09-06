require 'rails_helper'

RSpec.describe RoleSerializer, type: :model do
  let(:user) { build(:user) }
  subject { RoleSerializer.new(user.role).to_json }

  %w[id name short_description long_description].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
