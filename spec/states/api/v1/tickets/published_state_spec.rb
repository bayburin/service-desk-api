require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe PublishedState do
        let!(:ticket) { create(:ticket, state: :published) }
        subject { PublishedState.new(ticket) }

        it 'inherits from AbstractState' do
          expect(PublishedState).to be < AbstractState
        end

        describe '#update' do
          before { allow_any_instance_of(UpdatePublishedTicket).to receive(:update).and_return(true) }

          it 'calls #update method for UpdatePublishedTicket instance' do
            expect_any_instance_of(UpdatePublishedTicket).to receive(:update)

            subject.update({})
          end

          it 'returns true' do
            expect(subject.update({})).to be_truthy
          end

          context 'when UpdatePublishedTicket#update returns false' do
            let(:custom_error) { 'test error' }
            let(:update_ticket) { UpdatePublishedTicket.new(ticket) }
            before do
              allow(UpdatePublishedTicket).to receive(:new).and_return(update_ticket)
              allow(update_ticket).to receive(:update).and_return(false)
            end

            it 'returns false' do
              expect(subject.update({})).to be_falsey
            end

            it 'merge ticket errors with errors of UpdatePublishedTicket instance' do
              update_ticket.errors.add(:base, custom_error)
              subject.update({})

              expect(subject.ticket.errors.full_messages).to include(custom_error)
            end
          end
        end

        describe '#publish' do
          it 'should raise error' do
            expect { subject.publish }.to raise_error(RuntimeError, 'Вопрос уже опубликован')
          end
        end
      end
    end
  end
end
