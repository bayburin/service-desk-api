require 'rails_helper'

module Api
  module V1
    RSpec.describe ReportSender do
      let(:operator) { create(:operator_user) }
      let(:manager) { create(:content_manager_user) }
      let(:object) { {} }
      let(:sender) { double(:sender, send: true) }
      subject { ReportSender.new(manager, object, operator) }

      describe '#send_report' do
        it 'calls :send method for received instance' do
          expect(sender).to receive(:send).with(manager, object, operator)

          subject.send_report(sender)
        end
      end
    end
  end
end
