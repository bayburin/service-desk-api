require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe QuestionFactory do
        describe '#create' do
          let(:question) { subject.create }

          it 'returns instance of Ticket class' do
            expect(question).to be_instance_of Ticket
          end

          it 'sets question params' do
            expect(question.question_ticket?).to be_truthy
            expect(question.draft_state?).to be_truthy
            expect(question.to_approve).to be_falsey
          end
        end
      end
    end
  end
end
