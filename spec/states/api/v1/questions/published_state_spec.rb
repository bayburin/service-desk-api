require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe PublishedState do
        let!(:question) { create(:question, state: :published) }
        subject { PublishedState.new(question) }

        it 'inherits from AbstractState' do
          expect(described_class).to be < AbstractState
        end

        describe '#update' do
          let(:params) { {} }
          before do
            allow_any_instance_of(UpdatePublishedForm).to receive(:validate).and_return(true)
            allow_any_instance_of(UpdatePublishedForm).to receive(:save).and_return(true)
          end

          it 'create instance with current question' do
            expect(UpdatePublishedForm).to receive(:new).with(question).and_call_original

            subject.update(params)
          end

          it 'call #validate method for UpdatePublishedForm instance' do
            expect_any_instance_of(UpdatePublishedForm).to receive(:validate).with(params)

            subject.update(params)
          end

          it 'call #save method for UpdatePublishedForm instance' do
            expect_any_instance_of(UpdatePublishedForm).to receive(:save)

            subject.update(params)
          end

          it 'return true' do
            expect(subject.update(params)).to be_truthy
          end

          context 'when UpdatePublishedForm#validate returns false' do
            let(:custom_error) { 'test error' }
            before { allow_any_instance_of(UpdatePublishedForm).to receive(:validate).and_return(false) }

            it 'return false' do
              expect(subject.update(params)).to be_falsey
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
