require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe DraftState do
        let!(:ticket) { create(:ticket, state: :draft) }
        subject { DraftState.new(ticket) }

        it 'inherits from AbstractState' do
          expect(DraftState).to be < AbstractState
        end

        describe '#update' do
          it 'calls update method for ticket' do
            expect(ticket).to receive(:update)

            subject.update({})
          end
        end
      end
    end
  end
end
