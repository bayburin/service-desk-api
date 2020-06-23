require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe TicketBaseSerializer, type: :model do
        let(:ticket) { create(:ticket) }
        subject { TicketBaseSerializer.new(ticket) }

        %w[id service_id name ticketable_id ticketable_type state is_hidden sla popularity service].each do |attr|
          it "has #{attr} attribute" do
            expect(subject.to_json).to have_json_path(attr)
          end
        end
      end
    end
  end
end
