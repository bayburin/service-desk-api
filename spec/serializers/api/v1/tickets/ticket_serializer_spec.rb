require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe TicketSerializer, type: :model do
        let(:ticket) { create(:ticket) }
        subject { TicketResponsibleUserSerializer.new(ticket) }

        it 'inherits from TicketBaseSerializer class' do
          expect(described_class).to be < TicketBaseSerializer
        end

        %w[responsible_users tags].each do |attr|
          it "has #{attr} attribute" do
            expect(subject.to_json).to have_json_path(attr)
          end
        end

        # describe '#answers' do
        #   it 'creates instance of AnswerPolicy::Scope' do
        #     parse_json(subject.to_json)['answers'].each do |answer|
        #       expect(answer['is_hidden']).to be_falsey
        #     end
        #   end
        # end
      end
    end
  end
end
