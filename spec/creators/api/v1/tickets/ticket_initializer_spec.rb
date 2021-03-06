require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe TicketInitializer do
        subject { TicketInitializer }

        describe '#for' do
          context 'with :app type' do
            # it 'returns instance of AppFactory' do
            #   expect(subject.for('app')).to be_instance_of(AppFactory)
            # end
          end

          context 'with :question type' do
            it 'returns instance of QuestionFactory' do
              expect(subject.for('question')).to be_instance_of(QuestionFactory)
            end
          end

          context 'with another type' do
            it 'raise error' do
              expect { subject.for('test') }.to raise_error(RuntimeError, 'Неизвестный тип Ticket')
            end
          end
        end
      end
    end
  end
end
