require 'rails_helper'

RSpec.describe CaseDashboardSerializer, type: :model do
  let(:kase) { build(:case) }
  let(:case_attributes) { Oj.load(CaseSerializer.new(kase).to_json) }
  let(:data) { { cases: [kase], statuses: [] } }
  let(:case_dashboard) { CaseDashboard.new(data.as_json) }
  subject { CaseDashboardSerializer.new(case_dashboard).to_json }

  %w[statuses cases].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
