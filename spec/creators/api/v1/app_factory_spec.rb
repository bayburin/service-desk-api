require 'rails_helper'

module Api
  module V1
    RSpec.describe AppFactory do
      subject { AppFactory }

      describe '#create' do
        let(:app) { subject.create }

        it 'returns instance of Ticket class' do
          expect(app).to be_instance_of App
        end
      end
    end
  end
end
