require 'rails_helper'

module Api
  module V1
    RSpec.describe AppDashboardSerializer, type: :model do
      let(:app) { build(:app, id: 1) }
      let(:data) { { apps: [app], statuses: [] } }
      let(:app_dashboard) { AppDashboard.new(data) }
      subject { AppDashboardSerializer.new(app_dashboard).to_json }

      %w[statuses apps].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
