require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe Publish, type: :model do
        let(:popularity) { 50 }
        let(:original) { create(:question, state: :published, popularity: popularity) }
        let!(:question) { create(:question, state: :draft, original: original, popularity: 0) }
        subject { Publish.new(question) }

        it 'inherits from ApplicationService class' do
          expect(Create).to be < ApplicationService
        end

        context 'when ticket is not set' do
          before { allow(subject).to receive(:ticket).and_return(nil) }

          it 'return false' do
            expect(subject.call).to be_falsey
          end
        end

        context 'when answers is not empty' do
          before { allow(subject).to receive(:answers).and_return([]) }

          it 'return false' do
            expect(subject.call).to be_falsey
          end
        end

        context 'when question has original' do
          it 'destroyes original question' do
            subject.call
            question.reload

            expect(question.original).to be_nil
          end

          it 'sets :published state' do
            subject.call
            question.reload

            expect(question.ticket.published_state?).to be_truthy
          end

          it 'clones popularity from original' do
            subject.call
            question.reload

            expect(question.ticket.popularity).to eq popularity
          end

          context 'when original was not destroyed' do
            before { allow(question.original).to receive(:destroy).and_return(false) }

            it 'does not change state' do
              subject.call
              question.reload

              expect(question.ticket.published_state?).to be_falsey
            end
          end
        end

        context 'when ticket does not have original' do
          before { question.original = nil }

          it 'updates ticket' do
            subject.call

            expect(question.ticket.published_state?).to be_truthy
          end
        end
      end
    end
  end
end
