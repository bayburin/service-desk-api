require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe QuestionForm, type: :model do
        subject { described_class.new(Question.new) }
        let(:params) { { ticket: { name: 'test' } } }

        it_behaves_like 'TicketableForm' do
          let(:ticketable_object) { create(:question) }
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
      end
    end
  end
end
