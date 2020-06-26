require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe UpdatePublishedQuestion do
        let!(:question) { create(:question, state: :published) }
        let(:ticket) { question.ticket }
        let!(:responsible_users) { create_list(:responsible_user, 2, responseable: ticket) }
        subject { UpdatePublishedQuestion.new(question) }

        it 'includes ActiveModel::Validations' do
          expect(subject.singleton_class.ancestors).to include(ActiveModel::Validations)
        end

        describe '#update' do
          let(:updated_attributes) do
            attrs = question.as_json.deep_symbolize_keys
            attrs[:answers_attributes] = [attributes_for(:answer)]
            attrs[:ticket_attributes] = ticket.as_json.symbolize_keys
            attrs[:ticket_attributes][:responsible_users_attributes] = responsible_users.as_json.map(&:symbolize_keys)
            attrs
          end

          context 'when ticket has correction' do
            let(:correction) { create(:question, state: :draft, original: question) }
            before { question.correction = correction }

            it 'does not update original' do
              subject.update(updated_attributes)

              expect(correction.original).to eq question
            end

            it 'does not create a correction' do
              expect { subject.update(updated_attributes) }.not_to change { Question.count }
            end

            it 'does not create a new ticket' do
              expect { subject.update(updated_attributes) }.not_to change { Ticket.count }
            end
          end

          it 'creates a new question' do
            expect { subject.update(updated_attributes) }.to change { Question.count }.by(1)
          end

          it 'creates a new ticket' do
            expect { subject.update(updated_attributes) }.to change { Ticket.count }.by(1)
          end

          it 'clones attributes from original question' do
            subject.update(updated_attributes)

            expect(subject.question.original_id).to eq question.id
          end

          it 'clones attributes from original ticket' do
            subject.update(updated_attributes)

            expect(subject.question.ticket.service_id).to eq ticket.service_id
            expect(subject.question.ticket.popularity).to eq ticket.popularity
            expect(subject.question.ticket.sla).to eq ticket.sla
          end

          it 'clones responsible_users' do
            subject.update(updated_attributes)

            expect(subject.question.ticket.responsible_users.pluck(:tn)).to eq responsible_users.pluck(:tn)
          end

          it 'calls Tickets::TicketFactory.create method' do
            expect(Tickets::TicketFactory).to receive(:create).with(:question, hash_including(original_id: ticket.id)).and_call_original

            subject.update(updated_attributes)
          end

          context 'when answer does not changed' do
            let(:updated_attributes) do
              attrs = question.as_json.deep_symbolize_keys
              attrs[:answers_attributes] = question.answers.map { |answer| answer.as_json.deep_symbolize_keys }
              attrs[:ticket_attributes] = ticket.as_json.deep_symbolize_keys
              attrs[:ticket_attributes][:responsible_users_attributes] = []
              attrs
            end
            let(:attachments_size) { question.answers.inject(0) { |sum, answer| sum + answer.attachments.count } }

            it 'clones attachments' do
              expect { subject.update(updated_attributes) }.to change { AnswerAttachment.count }.by(attachments_size)
            end
          end
        end
      end
    end
  end
end