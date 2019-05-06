require 'rails_helper'

module Api
  module V1
    RSpec.describe CategoriesQuery, type: :model do
      let!(:categories) { create_list(:category, 5) }

      it 'inherits from ApplicationQuery class' do
        expect(CategoriesQuery).to be < ApplicationQuery
      end

      context 'when scope does not exist' do
        it 'creates scope' do
          expect(subject.scope).to eq Category.all
        end
      end

      context 'when scope exists' do
        let(:scope) { Category.first(2) }
        subject { CategoriesQuery.new(scope) }

        it 'use current scope' do
          expect(subject.scope).to eq scope
        end
      end

      describe '#all' do
        it 'loads all categories' do
          expect(subject.all.count).to eq categories.count
        end

        it 'runs scope :by_popularity' do
          expect(subject.scope).to receive(:by_popularity)

          subject.all
        end
      end
    end
  end
end
