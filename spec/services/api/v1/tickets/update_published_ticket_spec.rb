require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe UpdatePublishedTicket do
        let!(:ticket) { create(:ticket, state: :published) }
        let!(:responsible_users) { create_list(:responsible_user, 2, responseable: ticket) }
        subject { UpdatePublishedTicket.new(ticket) }

        it 'includes ActiveModel::Validations' do
          expect(subject.singleton_class.ancestors).to include(ActiveModel::Validations)
        end

        describe '#update' do
          let(:updated_attributes) do
            attrs = ticket.as_json.deep_symbolize_keys
            attrs[:answers_attributes] = [attributes_for(:answer)]
            attrs[:responsible_users_attributes] = responsible_users.as_json.map { |u| u.symbolize_keys }
            attrs
          end

          context 'when ticket has correction' do
            let(:correction) { create(:ticket, state: :draft, original: ticket) }
            before { ticket.correction = correction }

            it 'does not update original' do
              subject.update(updated_attributes)

              expect(correction.original).to eq ticket
            end

            it 'does not create correction' do
              expect { subject.update(updated_attributes) }.not_to change { Ticket.count }
            end
          end

          it 'creates a new record' do
            expect { subject.update(updated_attributes) }.to change { Ticket.count }.by(1)
          end

          it 'clones attributes from original' do
            subject.update(updated_attributes)

            expect(subject.ticket.service_id).to eq ticket.service_id
            expect(subject.ticket.original_id).to eq ticket.id
            expect(subject.ticket.popularity).to eq ticket.popularity
            expect(subject.ticket.sla).to eq ticket.sla
            expect(subject.ticket.to_approve).to eq ticket.to_approve
          end

          it 'clones responsible_users' do
            subject.update(updated_attributes)

            expect(subject.ticket.responsible_users.pluck(:tn)).to eq responsible_users.pluck(:tn)
          end

          it 'calls Tickets::TicketFactory.create method' do
            expect(Tickets::TicketFactory).to receive(:create).with(:question, hash_including(original_id: ticket.id)).and_call_original

            subject.update(updated_attributes)
          end

          context 'when answer does not changed' do
            let(:updated_attributes) do
              attrs = ticket.as_json.deep_symbolize_keys
              attrs[:answers_attributes] = ticket.answers.map { |answer| answer.as_json.deep_symbolize_keys }
              attrs[:responsible_users_attributes] = []
              attrs
            end
            let(:attachments_size) { ticket.answers.inject(0) { |sum, answer| sum + answer.attachments.count } }

            it 'clones attachments' do
              expect { subject.update(updated_attributes) }.to change { AnswerAttachment.count }.by(attachments_size)
            end
          end
        end
      end
    end
  end
end
