require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe QuestionGuestSerializer, type: :model do
        let(:question) { create(:question) }
        subject { QuestionGuestSerializer.new(question) }

        it 'inherits from QuestionBaseSerializer class' do
          expect(QuestionGuestSerializer).to be < QuestionBaseSerializer
        end

        describe '#ticket' do
          it 'calls AnswerSerializer for :faq association' do
            expect(Api::V1::Tickets::TicketGuestSerializer).to receive(:new).and_call_original

            subject.to_json
          end
        end

        describe '#answers' do
          before { create(:answer, question: question, is_hidden: true) }

          it 'returns all visible answers' do
            parse_json(subject.to_json)['answers'].each do |answer|
              expect(answer['is_hidden']).to be_falsey
            end
          end
        end
      end
    end
  end
end
