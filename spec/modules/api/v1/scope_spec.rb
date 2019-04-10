require 'rails_helper'

module Api
  module V1
    describe 'Scope' do
      subject { Category.extend(Scope) }
      before { create_list(:category, 3) }

      describe '::by_priority' do
        it 'return instance of ActiveRecord::Relation' do
          expect(subject.by_popularity).to be_kind_of(ActiveRecord::Relation)
        end

        it 'order array' do
          expect(subject.by_popularity).to eq Category.order('popularity DESC')
        end
      end
    end
  end
end
