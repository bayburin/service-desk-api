require 'rails_helper'

module Api
  module V1
    module Services
      RSpec.describe ServiceBaseSerializer, type: :model do
        let(:service) { create(:service) }
        let!(:ticket) { create(:ticket, service: service) }
        let(:current_user) { create(:user) }
        subject { ServiceBaseSerializer.new(service, scope: current_user, scope_name: :current_user) }

        %w[id category_id name short_description install popularity is_hidden has_common_case popularity category].each do |attr|
          it "has #{attr} attribute" do
            expect(subject.to_json).to have_json_path(attr)
          end
        end

        # describe '#tickets' do
        #   it 'calls Tickets::TicketSerializer for :faq association' do
        #     expect(Tickets::TicketSerializer).to receive(:new).exactly(service.tickets.count).times.and_call_original

        #     subject.to_json
        #   end
        # end

        describe '#category' do
          it 'calls Categories::CategoryBaseSerializer for :faq association' do
            expect(Categories::CategoryBaseSerializer).to receive(:new).and_call_original

            subject.to_json
          end
        end

        describe '#include_associations?' do
          context 'when :without_associations attribute setted to true' do
            let(:service) { create(:service, without_associations: true) }

            it 'returns false' do
              expect(subject).to receive(:include_associations?).at_least(1).and_return(false)

              subject.to_json
            end

            %w[questions app_templates category responsible_users].each do |attr|
              it "does not have :#{attr} attribute" do
                expect(subject.to_json).not_to have_json_path(attr)
              end
            end
          end

          context 'when :without_associations attribute setted to false' do
            let(:service) { create(:service, without_associations: false) }

            it 'returns true' do
              expect(subject).to receive(:include_associations?).at_least(1).and_return(true)

              subject.to_json
            end

            %w[category responsible_users].each do |attr|
              it "has :#{attr} attribute" do
                expect(subject.to_json).to have_json_path(attr)
              end
            end
          end
        end

        describe 'include_authorize_attributes_for' do
          let(:authorize_attributes) { [answers: :attachments] }

          before { allow(subject).to receive(:instance_options).and_return(authorize_attributes: authorize_attributes) }

          it 'calls :includes method with attributes from :instance_options atrribute' do
            expect(service.tickets).to receive(:includes).with(authorize_attributes)

            subject.include_authorize_attributes_for(service.tickets)
          end

          context 'when any ticket has :without_associations attibute' do
            before { allow_any_instance_of(Ticket).to receive(:without_associations).and_return(true) }

            it 'does not call :includes method' do
              expect(service.tickets).not_to receive(:includes).with(authorize_attributes)

              subject.include_authorize_attributes_for(service.tickets)
            end
          end
        end
      end
    end
  end
end
