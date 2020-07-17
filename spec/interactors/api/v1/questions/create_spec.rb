require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe Create do
        let(:question) { Question.new }
        let(:created_question) { create(:question) }
        let(:question_params) { {} }
        let(:create_form_dbl) { double(:create_form, validate: true, save: true, model: created_question) }
        subject(:context) { described_class.call(params: question_params) }
        before do
          allow(Question).to receive(:new).and_return(question)
          allow(Questions::QuestionForm).to receive(:new).and_return(create_form_dbl)
        end

        describe '.call' do
          it 'create instance of Questions::QuestionForm' do
            expect(Questions::QuestionForm).to receive(:new).with(question)

            described_class.call(params: question_params)
          end

          context 'when form is saved' do
            before { described_class.call(params: question_params) }

            it 'finished with success' do
              expect(context).to be_a_success
            end

            it 'set created question to context' do
              expect(context.question).to eq question
            end
          end

          context 'when form is not saved' do
            let(:create_form_dbl) { double(:create_form, validate: false, save: false, errors: { message: 'test' }) }

            it 'finished with error' do
              expect(context).to be_a_failure
            end

            it 'set error to context' do
              expect(context.errors).to be_present
            end
          end
        end
      end
    end
  end
end
