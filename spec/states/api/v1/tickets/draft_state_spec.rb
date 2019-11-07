require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe DraftState do
        let(:popularity) { 50 }
        let(:original) { create(:ticket, state: :published, popularity: popularity) }
        let!(:ticket) { create(:ticket, state: :draft, original: original, popularity: 0) }
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

        describe '#publish' do
          context 'when ticket has original' do
            it 'destroyes original ticket' do
              subject.publish
              ticket.reload

              expect(ticket.original).to be_nil
            end

            it 'sets :published state' do
              subject.publish
              ticket.reload

              expect(ticket.published_state?).to be_truthy
            end

            it 'clones popularity from original' do
              subject.publish
              ticket.reload

              expect(ticket.popularity).to eq popularity
            end

            context 'when original was not destroyed' do
              before { allow(ticket.original).to receive(:destroy).and_return(false) }

              it 'does not change state' do
                subject.publish
                ticket.reload

                expect(ticket.published_state?).to be_falsey
              end
            end
          end

          context 'when ticket does not have original' do
            before { ticket.original = nil }

            it 'updates ticket' do
              subject.publish

              expect(ticket.published_state?).to be_truthy
            end
          end
        end
      end
    end
  end
end
