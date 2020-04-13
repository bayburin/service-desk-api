require 'rails_helper'

module Api
  module V1
    module Categories
      RSpec.describe CategoryBaseSerializer, type: :model do
        let(:current_user) { create(:guest_user) }
        let(:category) { create(:category) }
        subject { CategoryBaseSerializer.new(category, scope: current_user, scope_name: :current_user) }

        %w[id name short_description icon_name popularity services faq].each do |attr|
          it "has #{attr} attribute" do
            expect(subject.to_json).to have_json_path(attr)
          end
        end

        describe '#include_associations?' do
          context 'when :without_associations attribute setted to true' do
            let(:category) { create(:category, without_associations: true) }

            it 'returns false' do
              expect(subject).to receive(:include_associations?).at_least(1).and_return(false)

              subject.to_json
            end

            %w[services faq].each do |attr|
              it "does not have :#{attr} attribute" do
                expect(subject.to_json).not_to have_json_path(attr)
              end
            end
          end

          context 'when :without_associations attribute setted to false' do
            let(:category) { create(:category, without_associations: false) }

            it 'returns true' do
              expect(subject).to receive(:include_associations?).at_least(1).and_return(true)

              subject.to_json
            end

            %w[services faq].each do |attr|
              it "has :#{attr} attribute" do
                expect(subject.to_json).to have_json_path(attr)
              end
            end
          end
        end

        describe '#services' do
          it 'calls Services::ServiceBaseSerializer for :services association' do
            expect(Services::ServiceBaseSerializer).to receive(:new).exactly(category.services.count).times.and_call_original

            subject.to_json
          end

          it 'calls :policy_scope method for services' do
            expect(subject).to receive(:policy_scope).with(category.services)

            subject.to_json
          end
        end

        describe '#faq' do
          before { create_list(:service, 2, category: category) }

          it 'calls QuestionTickets::QuestionTicketBaseSerializer for :faq association' do
            expect(QuestionTickets::QuestionTicketBaseSerializer).to receive(:new).exactly(5).times.and_call_original

            subject.to_json
          end

          it 'create instance of Api::V1::QuestionTicketsQuery' do
            expect(Api::V1::QuestionTicketsQuery).to receive(:new).with(category.question_tickets).and_call_original

            subject.to_json
          end

          it 'calls :most_popular method' do
            expect_any_instance_of(Api::V1::QuestionTicketsQuery).to receive(:most_popular)

            subject.to_json
          end
        end
      end
    end
  end
end
