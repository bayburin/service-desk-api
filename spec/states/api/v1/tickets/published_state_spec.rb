require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe PublishedState do
        let!(:ticket) { create(:ticket, state: :published) }
        subject { PublishedState.new(ticket) }

        it 'inherits from AbstractState' do
          expect(PublishedState).to be < AbstractState
        end

        describe '#update' do
          let(:updated_attributes) do
            attrs = ticket.as_json.deep_symbolize_keys
            attrs[:answers_attributes] = [attributes_for(:answer)]
            attrs
          end

          it 'creates a new record' do
            expect { subject.update(updated_attributes) }.to change { Ticket.count }.by(1)
          end

          it 'clones attributes from original' do
            subject.update(updated_attributes)

            expect(subject.object.service_id).to eq ticket.service_id
            expect(subject.object.original_id).to eq ticket.id
            expect(subject.object.popularity).to eq ticket.popularity
            expect(subject.object.sla).to eq ticket.sla
            expect(subject.object.to_approve).to eq ticket.to_approve
          end

          it 'sets :draft state and :question type in created record' do
            subject.update(updated_attributes)

            expect(subject.object.draft_state?).to be_truthy
            expect(subject.object.question_ticket?).to be_truthy
          end
        end
      end
    end
  end
end
