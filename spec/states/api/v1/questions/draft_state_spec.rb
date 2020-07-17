require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe DraftState do
        let(:popularity) { 50 }
        let(:original) { create(:question, state: :published, popularity: popularity) }
        let!(:question) { create(:question, state: :draft, original: original, popularity: 0) }
        subject { DraftState.new(question) }

        it 'inherits from AbstractState' do
          expect(DraftState).to be < AbstractState
        end

        describe '#update' do
          let(:params) { {} }
          before do
            allow_any_instance_of(QuestionForm).to receive(:validate).and_return(true)
            allow_any_instance_of(QuestionForm).to receive(:save).and_return(true)
          end

          it 'create instance with current question' do
            expect(QuestionForm).to receive(:new).with(question).and_call_original

            subject.update(params)
          end

          it 'call #validate method for QuestionForm instance' do
            expect_any_instance_of(QuestionForm).to receive(:validate).with(params)

            subject.update(params)
          end

          it 'call #save method for QuestionForm instance' do
            expect_any_instance_of(QuestionForm).to receive(:save)

            subject.update(params)
          end

          it 'return true' do
            expect(subject.update(params)).to be_truthy
          end

          context 'when QuestionForm#validate returns false' do
            let(:custom_error) { 'test error' }
            before { allow_any_instance_of(QuestionForm).to receive(:validate).and_return(false) }

            it 'return false' do
              expect(subject.update(params)).to be_falsey
            end
          end
        end

        describe '#publish' do
          it 'call Publish class' do
            expect(Publish).to receive(:new).with(question).and_call_original

            subject.publish
          end

          context 'when publish finished' do
            before { allow_any_instance_of(Publish).to receive(:call).and_return(true) }

            it 'return true' do
              expect(subject.publish).to be_truthy
            end
          end

          context 'when publish falied' do
            before { allow_any_instance_of(Publish).to receive(:call).and_return(false) }

            it 'return false' do
              expect(subject.publish).to be_falsey
            end
          end
        end

        describe '#destroy' do
          it 'destroys ticket' do
            expect { subject.destroy }.to change { Ticket.count }.by(-1)
          end

          it 'destroys question' do
            expect { subject.destroy }.to change { Question.count }.by(-1)
          end
        end
      end
    end
  end
end
