require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe PublishedState do
        let!(:question) { create(:question, state: :published) }
        subject { PublishedState.new(question) }

        it 'inherits from AbstractState' do
          expect(PublishedState).to be < AbstractState
        end

        describe '#update' do
          before { allow_any_instance_of(UpdatePublishedQuestion).to receive(:update).and_return(true) }

          it 'call #update method for UpdatePublishedQuestion instance' do
            expect_any_instance_of(UpdatePublishedQuestion).to receive(:update).with({})

            subject.update({})
          end

          it 'return true' do
            expect(subject.update({})).to be_truthy
          end

          context 'when UpdatePublishedQuestion#update returns false' do
            let(:custom_error) { 'test error' }
            let(:update_ticket) { UpdatePublishedQuestion.new(question) }
            before do
              allow(UpdatePublishedQuestion).to receive(:new).and_return(update_ticket)
              allow(update_ticket).to receive(:update).and_return(false)
            end

            it 'return false' do
              expect(subject.update({})).to be_falsey
            end

            it 'merge ticket errors with errors of UpdatePublishedTicket instance' do
              update_ticket.errors.add(:base, custom_error)
              subject.update({})

              expect(subject.question.errors.full_messages).to include(custom_error)
            end
          end
        end

        describe '#publish' do
          it 'should raise error' do
            expect { subject.publish }.to raise_error(RuntimeError, 'Вопрос уже опубликован')
          end
        end

        describe '#destroy' do
          context 'when ticket has correction' do
            let(:correction) { create(:question) }
            before { question.correction = correction }

            it 'destroys correction and ticket' do
              expect { subject.destroy }.to change { Ticket.count }.by(-2)
            end

            context 'when correction was not destroyed' do
              before { allow(correction).to receive(:destroy).and_return(false) }

              it 'does not destroy original' do
                expect { subject.destroy }.not_to change { Question.count }
              end

              it 'does not destroy ticket which belongs to original ticket' do
                expect { subject.destroy }.not_to change { Ticket.count }
              end
            end
          end

          context 'when ticket does not have correction' do
            it 'destroys ticket' do
              expect { subject.destroy }.to change { Question.count }.by(-1)
            end
          end
        end
      end
    end
  end
end
