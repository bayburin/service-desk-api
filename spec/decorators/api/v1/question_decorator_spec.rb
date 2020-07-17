require 'rails_helper'

module Api
  module V1
    RSpec.describe QuestionDecorator, type: :model do
      let!(:question) { create(:question) }
      let(:ticket) { question.ticket }
      subject { QuestionDecorator.new(question) }

      it 'inherits from SimpleDelegator class' do
        expect(described_class).to be < SimpleDelegator
      end

      describe '#update_by_state' do
        context 'when ticket has published state' do
          before do
            ticket.state = :published
            allow_any_instance_of(Api::V1::Questions::PublishedState).to receive(:update).and_return(true)
          end

          it 'creates Api::V1::Questions::PublishedState instance' do
            expect(Api::V1::Questions::PublishedState).to receive(:new).with(subject).and_call_original

            subject.update_by_state(question.as_json)
          end

          it 'calls update method for Api::V1::Questions::PublishedState instance' do
            expect_any_instance_of(Api::V1::Questions::PublishedState).to receive(:update).and_return(true)

            subject.update_by_state(question.as_json)
          end
        end

        context 'when ticket has draft state' do
          before do
            ticket.state = :draft
            allow_any_instance_of(Api::V1::Questions::DraftState).to receive(:update).and_return(true)
          end

          it 'creates Api::V1::Questions::DraftState instance' do
            expect(Api::V1::Questions::DraftState).to receive(:new).with(subject).and_call_original

            subject.update_by_state(question.as_json)
          end

          it 'calls update method for Api::V1::Questions::DraftState instance' do
            expect_any_instance_of(Api::V1::Questions::DraftState).to receive(:update).and_return(true)

            subject.update_by_state(question.as_json)
          end
        end
      end

      describe '#destroy_by_state' do
        context 'when ticket has published state' do
          before do
            ticket.state = :published
            allow_any_instance_of(Api::V1::Questions::PublishedState).to receive(:destroy).and_return(true)
          end

          it 'creates Api::V1::Questions::PublishedState instance' do
            expect(Api::V1::Questions::PublishedState).to receive(:new).with(subject).and_call_original

            subject.destroy_by_state
          end

          it 'calls destroy method for Api::V1::Questions::PublishedState instance' do
            expect_any_instance_of(Api::V1::Questions::PublishedState).to receive(:destroy).and_return(true)

            subject.destroy_by_state
          end
        end

        context 'when ticket has draft state' do
          before do
            ticket.state = :draft
            allow_any_instance_of(Api::V1::Questions::DraftState).to receive(:destroy).and_return(true)
          end

          it 'creates Api::V1::Questions::DraftState instance' do
            expect(Api::V1::Questions::DraftState).to receive(:new).with(subject).and_call_original

            subject.destroy_by_state
          end

          it 'calls destroy method for Api::V1::Questions::DraftState instance' do
            expect_any_instance_of(Api::V1::Questions::DraftState).to receive(:destroy).and_return(true)

            subject.destroy_by_state
          end
        end
      end

      describe '#publish' do
        before { ticket.published_state! }

        it 'calls :publish method for instance of state' do
          expect_any_instance_of(Api::V1::Questions::PublishedState).to receive(:publish)

          subject.publish
        end
      end
    end
  end
end
