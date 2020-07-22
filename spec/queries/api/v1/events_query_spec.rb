require 'rails_helper'

module Api
  module V1
    RSpec.describe EventsQuery, type: :model do
      let!(:searches) { create_list(:search_event, 3) }
      let!(:deep_searches) { create_list(:deep_search_event, 4) }
      let(:scope) { searches + deep_searches }
      let!(:another_events) { create_list(:action_event, 2) }
      subject { described_class.new }

      it 'inherits from ApplicationQuery class' do
        expect(described_class).to be < ApplicationQuery
      end

      context 'when scope does not exist' do
        it 'create scope' do
          expect(subject.scope).to eq Ahoy::Event.all
        end
      end

      context 'when scope exists' do
        subject { described_class.new(scope) }

        it 'use current scope' do
          expect(subject.scope).to eq scope
        end
      end

      describe '#all_search_by' do
        let(:date) { Date.today }

        it 'return all search events' do
          expect(subject.all_search_by(date).count).to eq scope.count
        end

        it 'return events by specified date' do
          subject.all_search_by(date).each do |event|
            expect(event.time.to_date).to eq date
          end
        end
      end
    end
  end
end
