require 'rails_helper'

module Api
  module V1
    module QuestionTickets
      RSpec.describe QuestionTicketGuestSerializer, type: :model do
        let(:question) { create(:question_ticket) }
        subject { QuestionTicketGuestSerializer.new(question) }

        it 'inherits from QuestionTicketBaseSerializer class' do
          expect(QuestionTicketGuestSerializer).to be < QuestionTicketBaseSerializer
        end

        describe '#ticket' do
          it 'calls AnswerSerializer for :faq association' do
            expect(Api::V1::Tickets::TicketGuestSerializer).to receive(:new).and_call_original

            subject.to_json
          end
        end

        describe '#answers' do
          before { create(:answer, question_ticket: question, is_hidden: true) }

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
