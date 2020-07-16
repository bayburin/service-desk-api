require 'rails_helper'

module Api
  module V1
    module Categories
      RSpec.describe CategoryGuestSerializer, type: :model do
        let(:current_user) { create(:guest_user) }
        let(:category) { create(:category) }
        subject { CategoryGuestSerializer.new(category, scope: current_user, scope_name: :current_user) }

        it 'inherits from CategoryBaseSerializer class' do
          expect(described_class).to be < CategoryBaseSerializer
        end

        describe '#services' do
          it 'calls Services::ServiceGuestSerializer for :services association' do
            expect(Services::ServiceGuestSerializer).to receive(:new).exactly(category.services.count).times.and_call_original

            subject.to_json
          end

          it 'creates instance of Api::V1::ServicesQuery' do
            expect(Api::V1::ServicesQuery).to receive(:new).with(category.services).and_call_original

            subject.to_json
          end

          it 'calls :visible method' do
            expect_any_instance_of(Api::V1::ServicesQuery).to receive(:visible)

            subject.to_json
          end
        end

        describe '#faq' do
          before { create_list(:service, 2, category: category) }

          it 'calls Tickets::TicketGuestSerializer for :faq association' do
            expect(Questions::QuestionGuestSerializer).to receive(:new).exactly(5).times.and_call_original

            subject.to_json
          end
        end
      end
    end
  end
end
