require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe QuestionFactory do
        describe '#create' do
          let(:ticket) { build(:ticket) }
          let(:question) { subject.create(ticket: ticket) }

          it 'return instance of QuestionTicket class' do
            expect(question).to be_instance_of QuestionTicket
          end

          it 'sets question params' do
            expect(question.ticket.draft_state?).to be_truthy
          end
        end
      end
    end
  end
end
