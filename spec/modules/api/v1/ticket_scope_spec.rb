require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketScope do
      subject { Ticket.extend(TicketScope) }

      describe '#published' do
        let!(:draft_ticket) { create(:ticket, state: :draft) }
        let!(:published_ticket) { create(:ticket) }

        it 'return instance of ActiveRecord::Relation' do
          expect(subject.published).to be_kind_of(ActiveRecord::Relation)
        end

        it 'return only record with :published state' do
          expect(subject.published.first).to eq published_ticket
        end
      end
    end
  end
end
