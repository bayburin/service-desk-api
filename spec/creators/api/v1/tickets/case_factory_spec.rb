require 'rails_helper'

module Api
  module V1
    module Tickets
      RSpec.describe CaseFactory do
        describe '#create' do
          let(:kase) { subject.create }

          it 'returns instance of Ticket class' do
            expect(kase).to be_instance_of Case
          end
        end
      end
    end
  end
end
