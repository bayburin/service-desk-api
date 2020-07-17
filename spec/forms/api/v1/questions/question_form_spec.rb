require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe QuestionForm, type: :model do
        subject { described_class.new(Question.new) }
        let(:params) { { ticket: { name: 'test' } } }

        it 'add error if ticket is invalid' do
          allow_any_instance_of(TicketForm).to receive(:valid?).and_return(false)
          subject.validate(params)

          expect(subject.errors.details.keys).to include(:ticket)
        end

        describe '#populate_answers!' do
          let!(:question) { create(:question) }
          let(:answers) { question.answers }
          let(:new_answer) { attributes_for(:answer, question: nil) }
          let(:destroy_answer) do
            answer = answers.first.as_json
            answer[:_destroy] = true
            answer
          end
          let(:answer_params) do
            [
              destroy_answer,
              answers.last.as_json,
              new_answer
            ].map(&:symbolize_keys)
          end
          let(:params) { { answers: answer_params } }
          subject { described_class.new(question) }
          before { subject.validate(params) }

          it 'change count of answer collection' do
            expect(subject.answers.count).to eq 2
          end

          it 'add a new answer' do
            expect(subject.answers.any? { |a| a.answer == new_answer[:answer] }).to be_truthy
          end

          it 'remove answer with _destroy attribute' do
            expect(subject.answers.any? { |a| a.answer == destroy_answer[:answer] }).to be_falsey
          end
        end

        describe '#validate' do
          let(:question) { create(:question) }
          subject { described_class.new(question) }

          it 'call #populate_collections method for ticket property' do
            expect(subject.ticket).to receive(:populate_collections).with(params[:ticket])

            subject.validate(params)
          end
        end
      end
    end
  end
end
