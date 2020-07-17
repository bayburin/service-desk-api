require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe QuestionResponsibleUserSerializer, type: :model do
        let(:question) { create(:question) }
        subject { QuestionResponsibleUserSerializer.new(question) }

        it 'inherits from QuestionBaseSerializer class' do
          expect(described_class).to be < QuestionBaseSerializer
        end

        it 'has correction attribute' do
          expect(subject.to_json).to have_json_path('correction')
        end

        describe '#correction' do
          it 'calls Questions::QuestionResponsibleUserSerializer for :correction association' do
            expect(Api::V1::Questions::QuestionResponsibleUserSerializer).to receive(:new).exactly(2).times.and_call_original

            subject.to_json
          end
        end

        describe '#ticket' do
          it 'calls Tickets::TicketResponsibleUserSerializer for :ticket association' do
            expect(Api::V1::Tickets::TicketResponsibleUserSerializer).to receive(:new).and_call_original

            subject.to_json
          end
        end
      end
    end
  end
end
