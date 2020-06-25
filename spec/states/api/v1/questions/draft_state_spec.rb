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
          it 'calls update method for question' do
            expect(question).to receive(:update).with({})

            subject.update({})
          end
        end

        describe '#publish' do
          context 'when question has original' do
            it 'destroyes original question' do
              subject.publish
              question.reload

              expect(question.original).to be_nil
            end

            it 'sets :published state' do
              subject.publish
              question.reload

              expect(question.ticket.published_state?).to be_truthy
            end

            it 'clones popularity from original' do
              subject.publish
              question.reload

              expect(question.ticket.popularity).to eq popularity
            end

            context 'when original was not destroyed' do
              before { allow(question.original).to receive(:destroy).and_return(false) }

              it 'does not change state' do
                subject.publish
                question.reload

                expect(question.ticket.published_state?).to be_falsey
              end
            end
          end

          context 'when ticket does not have original' do
            before { question.original = nil }

            it 'updates ticket' do
              subject.publish

              expect(question.ticket.published_state?).to be_truthy
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
