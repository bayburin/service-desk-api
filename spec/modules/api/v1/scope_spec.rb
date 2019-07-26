require 'rails_helper'

module Api
  module V1
    RSpec.describe Scope do
      subject { Service.extend(Scope) }

      describe '#by_priority' do
        before { create_list(:service, 3) }

        it 'return instance of ActiveRecord::Relation' do
          expect(subject.by_popularity).to be_kind_of(ActiveRecord::Relation)
        end

        it 'order array' do
          expect(subject.by_popularity.map(&:id)).to eq Service.order('popularity DESC').map(&:id)
        end
      end

      describe '#visible' do
        before do
          create_list(:service, 3, is_hidden: false)
          create_list(:service, 3, is_hidden: true)
        end

        it 'return instance of ActiveRecord::Relation' do
          expect(subject.by_popularity).to be_kind_of(ActiveRecord::Relation)
        end

        it 'return only record with attribute :is_hidden setted to false' do
          subject.visible.each { |service| expect(service.is_hidden).to be_falsey }
        end
      end
    end
  end
end
