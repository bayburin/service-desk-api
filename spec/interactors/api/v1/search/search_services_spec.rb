require 'rails_helper'

module Api
  module V1
    module Search
      RSpec.describe SearchServices do
        let(:term) { 'search term' }
        let!(:services) { create_list(:service, 2, without_nested: true) }
        let!(:services_term) { create_list(:service, 3, name: term, without_nested: true) }
        let!(:filtered_service) { create(:service, without_nested: true) }
        let(:finded_by_sphinx) { services_term + [filtered_service] }
        let(:json_services) { services_term.as_json }
        let(:current_user) { create(:content_manager_user) }
        subject(:context) { described_class.call(user: current_user, term: term) }
        before do
          allow(Service).to receive(:search).and_return(finded_by_sphinx)
          allow_any_instance_of(ServicePolicy::SphinxScope).to receive(:resolve).and_return(services_term)
          allow_any_instance_of(ActiveModel::Serializer::CollectionSerializer).to receive(:as_json).and_return(json_services)
        end

        describe '.call' do
          it 'filter finded services by policy' do
            expect(ServicePolicy::SphinxScope).to receive(:new).with(current_user, finded_by_sphinx).and_call_original
            expect_any_instance_of(ServicePolicy::SphinxScope).to receive(:resolve).and_return(services_term)

            context
          end

          it 'save into service context filtered services' do
            expect(context.services).to eq services_term
          end

          it 'serialize finded services' do
            expect(ActiveModel::Serializer::CollectionSerializer).to(
              receive(:new).with(services_term, serializer: Services::ServiceGuestSerializer).and_call_original
            )
            expect_any_instance_of(ActiveModel::Serializer::CollectionSerializer).to receive(:as_json).and_return(json_services)

            context
          end

          it 'save into result context finded services at json format' do
            expect(context.result).to eq json_services
          end
        end
      end
    end
  end
end
