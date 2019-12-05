require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe TicketFactory do
        subject { TicketFactory }

        describe '#create' do
          let(:ticket) { subject.create }
          let(:question_factory_instance) { QuestionFactory.new }

          before { allow(TicketInitializer).to receive(:for).and_return(question_factory_instance) }

          it 'calls :create method for factory instance' do
            expect(question_factory_instance).to receive(:create)

            subject.create('question type')
          end
        end
      end
    end
  end
end
