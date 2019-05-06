require 'rails_helper'

module Api
  module V1
    RSpec.describe ServicesQuery, type: :model do
      let!(:services) { create_list(:service, 10) }

      it 'inherits from ApplicationQuery class' do
        expect(ServicesQuery).to be < ApplicationQuery
      end

      context 'when scope does not exist' do
        it 'creates scope' do
          expect(subject.scope).to eq Service.all
        end
      end

      context 'when scope exists' do
        let(:scope) { Service.first(2) }
        subject { ServicesQuery.new(scope) }

        it 'use current scope' do
          expect(subject.scope).to eq scope
        end
      end

      describe '#all' do
        it 'loads all services' do
          expect(subject.all.count).to eq services.count
        end

        it 'runs scope :by_popularity' do
          expect(subject.scope).to receive(:by_popularity)

          subject.all
        end
      end

      describe '#visible' do
        it 'runs :visible scope' do
          expect(subject).to receive_message_chain(:all, :visible)

          subject.visible
        end
      end

      describe '#most_popular' do
        it 'runs :all method' do
          expect(subject).to receive(:all).and_call_original

          subject.most_popular
        end

        it 'limits scope by 6 records' do
          expect(subject.most_popular.count).to eq 6
        end
      end
    end
  end
end
