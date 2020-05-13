require 'rails_helper'

module Api
  module V1
    RSpec.describe QuestionTicketChangedWorker, type: :worker do
      let(:ticket) { create(:ticket) }
      let!(:operator) { create(:operator_user, id_tn: 2, tn: 2) }
      let!(:manager) { create(:content_manager_user, id_tn: 3, tn: 3) }
      let!(:sec_manager) { create(:content_manager_user, id_tn: 4, tn: 4) }

      context 'when "create" type' do
        let(:type) { 'create' }
        let(:origin) { 'custom origin' }

        it 'calls Api::V1::NotifyContentManagerOnCreate worker for each manager' do
          expect(Api::V1::NotifyContentManagerOnCreate).to receive(:perform_async).with(manager.id, ticket.id, operator.id, origin)
          expect(Api::V1::NotifyContentManagerOnCreate).to receive(:perform_async).with(sec_manager.id, ticket.id, operator.id, origin)

          subject.perform(ticket.id, operator.id, type, origin)
        end
      end

      context 'when "update" type' do
        let(:type) { 'update' }
        let(:origin) { 'custom origin' }

        it 'calls Api::V1::NotifyContentManagerOnUpdate worker for each manager' do
          expect(Api::V1::NotifyContentManagerOnUpdate).to receive(:perform_async).with(manager.id, ticket.id, operator.id, origin)
          expect(Api::V1::NotifyContentManagerOnUpdate).to receive(:perform_async).with(sec_manager.id, ticket.id, operator.id, origin)

          subject.perform(ticket.id, operator.id, type, origin)
        end
      end
    end
  end
end
