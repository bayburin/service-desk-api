require 'rails_helper'

module Api
  module V1
    RSpec.describe NotifyContentManagersWorker, type: :worker do
      let(:ticket) { create(:ticket) }
      let!(:operator) { create(:operator_user, id_tn: 2, tn: 2) }
      let!(:manager) { create(:content_manager_user, id_tn: 3, tn: 3) }
      let!(:sec_manager) { create(:content_manager_user, id_tn: 4, tn: 4) }

      it 'calls Api::V1::NotifyContentManagerWorker worker for each manager' do
        expect(Api::V1::NotifyContentManagerWorker).to receive(:perform_async).with(manager.id, ticket.id, operator.id)
        expect(Api::V1::NotifyContentManagerWorker).to receive(:perform_async).with(sec_manager.id, ticket.id, operator.id)

        subject.perform(ticket.id, operator.id)
      end
    end
  end
end
