require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketDecorator, type: :model do
      let!(:ticket) { create(:ticket) }
      subject { TicketDecorator.new(ticket) }

      it 'inherits from SimpleDelegator class' do
        expect(TicketDecorator).to be < SimpleDelegator
      end

      describe '#update_by_state' do
        context 'when ticket has published state' do
          before do
            ticket.state = :published
            allow_any_instance_of(Api::V1::Tickets::PublishedState).to receive(:update).and_return(true)
          end

          it 'creates Api::V1::Tickets::PublishedState instance' do
            expect(Api::V1::Tickets::PublishedState).to receive(:new).with(subject).and_call_original

            subject.update_by_state(ticket.as_json)
          end

          it 'calls update method for Api::V1::Tickets::PublishedState instance' do
            expect_any_instance_of(Api::V1::Tickets::PublishedState).to receive(:update).and_return(true)

            subject.update_by_state(ticket.as_json)
          end
        end

        context 'when ticket has draft state' do
          before do
            subject.state = :draft
            allow_any_instance_of(Api::V1::Tickets::DraftState).to receive(:update).and_return(true)
          end

          it 'creates Api::V1::Tickets::DraftState instance' do
            expect(Api::V1::Tickets::DraftState).to receive(:new).with(subject).and_call_original

            subject.update_by_state(ticket.as_json)
          end

          it 'calls update method for Api::V1::Tickets::DraftState instance' do
            expect_any_instance_of(Api::V1::Tickets::DraftState).to receive(:update).and_return(true)

            subject.update_by_state(ticket.as_json)
          end
        end
      end

      describe '#destroy_by_state' do
        context 'when ticket has published state' do
          before do
            ticket.state = :published
            allow_any_instance_of(Api::V1::Tickets::PublishedState).to receive(:destroy).and_return(true)
          end

          it 'creates Api::V1::Tickets::PublishedState instance' do
            expect(Api::V1::Tickets::PublishedState).to receive(:new).with(subject).and_call_original

            subject.destroy_by_state
          end

          it 'calls destroy method for Api::V1::Tickets::PublishedState instance' do
            expect_any_instance_of(Api::V1::Tickets::PublishedState).to receive(:destroy).and_return(true)

            subject.destroy_by_state
          end
        end

        context 'when ticket has draft state' do
          before do
            subject.state = :draft
            allow_any_instance_of(Api::V1::Tickets::DraftState).to receive(:destroy).and_return(true)
          end

          it 'creates Api::V1::Tickets::DraftState instance' do
            expect(Api::V1::Tickets::DraftState).to receive(:new).with(subject).and_call_original

            subject.destroy_by_state
          end

          it 'calls destroy method for Api::V1::Tickets::DraftState instance' do
            expect_any_instance_of(Api::V1::Tickets::DraftState).to receive(:destroy).and_return(true)

            subject.destroy_by_state
          end
        end
      end

      describe '#publish' do
        before { ticket.published_state! }

        it 'calls :publish method for instance of state' do
          expect_any_instance_of(Api::V1::Tickets::PublishedState).to receive(:publish)

          subject.publish
        end
      end
    end
  end
end
