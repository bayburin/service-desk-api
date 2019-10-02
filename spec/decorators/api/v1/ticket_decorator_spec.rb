require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketDecorator, type: :model do
      let(:ticket) { build(:ticket) }
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
    end
  end
end
