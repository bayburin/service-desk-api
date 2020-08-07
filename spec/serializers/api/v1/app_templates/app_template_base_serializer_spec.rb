require 'rails_helper'

module Api
  module V1
    module AppTemplates
      RSpec.describe AppTemplateBaseSerializer, type: :model do
        let(:app_template) { create(:app_template) }
        subject { described_class.new(app_template) }

        %w[id description destination message info].each do |attr|
          it "has #{attr} attribute" do
            expect(subject.to_json).to have_json_path(attr)
          end
        end

        describe '#ticket' do
          it 'calls Tickets::TicketBaseSerializer for :ticket association' do
            expect(Api::V1::Tickets::TicketBaseSerializer).to receive(:new).and_call_original

            subject.to_json
          end
        end
      end
    end
  end
end
