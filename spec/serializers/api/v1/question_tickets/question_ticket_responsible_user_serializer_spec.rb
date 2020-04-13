require 'rails_helper'

module Api
  module V1
    module QuestionTickets
      RSpec.describe QuestionTicketResponsibleUserSerializer, type: :model do
        let(:question) { create(:question_ticket) }
        subject { QuestionTicketResponsibleUserSerializer.new(question) }

        it 'inherits from QuestionTicketBaseSerializer class' do
          expect(QuestionTicketResponsibleUserSerializer).to be < QuestionTicketBaseSerializer
        end

        it 'has correction attribute' do
          expect(subject.to_json).to have_json_path('correction')
        end

        describe '#correction' do
          it 'calls QuestionTickets::QuestionTicketResponsibleUserSerializer for :correction association' do
            expect(Api::V1::QuestionTickets::QuestionTicketResponsibleUserSerializer).to receive(:new).exactly(2).times.and_call_original

            subject.to_json
          end
        end

        describe '#ticket' do
          it 'calls QuestionTickets::QuestionTicketResponsibleUserSerializer for :ticket association' do
            expect(Api::V1::Tickets::TicketResponsibleUserSerializer).to receive(:new).and_call_original

            subject.to_json
          end
        end
      end
    end
  end
end
