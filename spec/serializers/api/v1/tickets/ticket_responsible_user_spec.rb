require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe TicketResponsibleUserSerializer, type: :model do
        let(:ticket) { create(:ticket) }
        subject { TicketResponsibleUserSerializer.new(ticket) }

        it 'inherits from TicketBaseSerializer class' do
          expect(TicketResponsibleUserSerializer).to be < TicketBaseSerializer
        end

        %w[responsible_users tags correction].each do |attr|
          it "has #{attr} attribute" do
            expect(subject.to_json).to have_json_path(attr)
          end
        end
      end
    end
  end
end
