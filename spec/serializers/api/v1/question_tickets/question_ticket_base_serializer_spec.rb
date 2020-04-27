require 'rails_helper'

module Api
  module V1
    module QuestionTickets
      RSpec.describe QuestionTicketBaseSerializer, type: :model do
        let(:question) { create(:question_ticket) }
        subject { QuestionTicketBaseSerializer.new(question) }

        %w[id original_id answers ticket].each do |attr|
          it "has #{attr} attribute" do
            expect(subject.to_json).to have_json_path(attr)
          end
        end

        describe '#answers' do
          it 'calls AnswerSerializer for :faq association' do
            expect(AnswerSerializer).to receive(:new).exactly(question.answers.count).times.and_call_original

            subject.to_json
          end
        end

        describe '#ticket' do
          it 'calls AnswerSerializer for :faq association' do
            expect(Api::V1::Tickets::TicketBaseSerializer).to receive(:new).and_call_original

            subject.to_json
          end
        end

        describe '#include_associations?' do
          context 'when :without_associations attribute setted to true' do
            let(:question) { create(:question_ticket, without_associations: true) }

            it 'returns false' do
              expect(subject).to receive(:include_associations?).at_least(1).and_return(false)

              subject.to_json
            end

            %w[answers].each do |attr|
              it "does not have #{attr} attribute" do
                expect(subject.to_json).not_to have_json_path(attr)
              end
            end
          end
        end
      end
    end
  end
end
