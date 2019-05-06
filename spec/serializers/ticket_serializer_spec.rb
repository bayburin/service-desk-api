require 'rails_helper'

RSpec.describe TicketSerializer, type: :model do
  let(:ticket) { create(:ticket) }
  subject { TicketSerializer.new(ticket).to_json }

  %w[id service_id name ticket_type is_hidden sla popularity answers tags service].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end
end
