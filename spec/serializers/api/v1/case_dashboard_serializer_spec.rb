require 'rails_helper'

module Api
  module V1
    RSpec.describe CaseDashboardSerializer, type: :model do
      let(:kase) { build(:case, id: 1) }
      let(:data) { { cases: [kase], statuses: [] } }
      let(:case_dashboard) { CaseDashboard.new(data) }
      subject { CaseDashboardSerializer.new(case_dashboard).to_json }

      %w[statuses cases].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
