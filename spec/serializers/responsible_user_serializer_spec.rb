require 'rails_helper'

RSpec.describe ResponsibleUserSerializer, type: :model do
  let(:user) { create(:service_responsible_user) }
  let(:service) { create(:service) }
  let(:responsible) { service.responsible_users.first }
  subject { ResponsibleUserSerializer.new(responsible).to_json }
  before { user.services << service }

  %w[id responseable_type responseable_id tn].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
