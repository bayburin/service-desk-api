require 'rails_helper'

module Api
  module V1
    RSpec.describe ReportSender do
      let(:user) { create(:content_manager_user) }
      let(:object) { {} }
      let(:sender) { double(:sender, send: true) }
      let(:params) { { foo: 'foo param', bar: 'bar param' } }
      subject { ReportSender.new(user, object, **params) }

      describe '#send_report' do
        it 'call :send method for received instance with params' do
          expect(sender).to receive(:send).with(user, object, **params)

          subject.send_report(sender)
        end
      end
    end
  end
end
