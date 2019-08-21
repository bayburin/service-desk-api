require 'rails_helper'

module Api
  module V1
    RSpec.describe ServiceScope do
      subject { Service.extend(ServiceScope) }

      describe '#by_tickets_responsible' do
        let(:service) { create(:service) }
        let(:ticket) { service.tickets.first }
        let(:user) { create(:service_responsible_user) }
        before { user.tickets << ticket }

        it 'return services belongs to user' do
          expect(subject.by_tickets_responsible(user).first).to eq service
        end
      end
    end
  end
end
