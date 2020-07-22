require 'rails_helper'

module Api
  module V1
    module Search
      RSpec.describe SearchCategories do
        let(:term) { 'search term' }
        let!(:categories) { create_list(:category, 2, without_nested: true) }
        let!(:categories_term) { create_list(:category, 3, name: term, without_nested: true) }
        let(:json_categories) { categories_term.as_json }
        subject(:context) { described_class.call(term: term) }
        before do
          allow(Category).to receive(:search).and_return(categories_term)
          allow_any_instance_of(ActiveModel::Serializer::CollectionSerializer).to receive(:as_json).and_return(json_categories)
        end

        describe '.call' do
          it 'save into category context finded categories' do
            expect(context.categories).to eq categories_term
          end

          it 'serialize finded categories' do
            expect(ActiveModel::Serializer::CollectionSerializer).to(
              receive(:new).with(categories_term, serializer: Categories::CategoryGuestSerializer).and_call_original
            )
            expect_any_instance_of(ActiveModel::Serializer::CollectionSerializer).to receive(:as_json).and_return(json_categories)

            context
          end

          it 'save into result context finded categories at json format' do
            expect(context.result).to eq json_categories
          end
        end
      end
    end
  end
end
