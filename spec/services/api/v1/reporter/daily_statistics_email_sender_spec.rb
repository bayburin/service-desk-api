require 'rails_helper'

module Api
  module V1
    module Reporter
      RSpec.describe DailyStatisticsEmailSender do
        let(:manager) { create(:content_manager_user) }
        let(:object) { %w[search1 search2] }
        let(:date) { Date.today.to_s }

        describe '#send' do
          it 'send email' do
            expect { subject.send(manager, object, date: date) }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end
    end
  end
end
