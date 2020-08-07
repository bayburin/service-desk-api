require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketableForm, type: :model do
      subject { described_class.new(Question.new) }

      it_behaves_like 'TicketableForm' do
        let(:ticketable_object) { create(:question) }
      end
    end
  end
end
