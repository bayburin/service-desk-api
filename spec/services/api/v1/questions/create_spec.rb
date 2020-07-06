require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe Create do
        let!(:service) { create(:service) }
        let(:answer) { attributes_for(:answer, question: nil) }
        let(:ticket_attrs) { attributes_for(:ticket, service_id: service.id, state: :draft, tags_attributes: [{ name: 'test' }]) }
        let(:question_attrs) { attributes_for(:question, answers_attributes: [answer], ticket_attributes: ticket_attrs) }
        subject { Create.new(question_attrs) }

        it 'inherits from ApplicationService class' do
          expect(Create).to be < ApplicationService
        end

        it 'return true' do
          expect(subject.call).to be_truthy
        end

        it 'create new question' do
          expect { subject.call }.to change { Question.count }.by(1)
        end

        it 'create new ticket' do
          expect { subject.call }.to change { Ticket.count }.by(1)
        end

        context 'when question was not created' do
          before { allow_any_instance_of(Ticket).to receive(:name).and_return('') }

          it 'return false' do
            expect(subject.call).to be_falsey
          end

          it 'merge question errors to service' do
            subject.call

            expect(subject.errors.details).to eq subject.data.errors.details
          end
        end
      end
    end
  end
end
