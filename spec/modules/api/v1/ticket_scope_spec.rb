require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketScope do
      subject { QuestionTicket.extend(TicketScope) }

      describe '#by_popularity' do
        before { create_list(:question_ticket, 3) }

        it 'order array' do
          expect(subject.includes(:ticket).by_popularity.map(&:id)).to eq QuestionTicket.joins(:ticket).order('popularity DESC').map(&:id)
        end
      end

      describe '#published' do
        let!(:draft_ticket) { create(:ticket, state: :draft) }
        let!(:published_ticket) { create(:ticket) }

        it 'return instance of ActiveRecord::Relation' do
          expect(subject.joins(:ticket).published).to be_kind_of(ActiveRecord::Relation)
        end

        it 'return only record with :published state' do
          subject.joins(:ticket).published.each do |q|
            expect(q.ticket.published_state?).to be_truthy
          end
        end
      end

      describe '#visible' do
        before do
          create_list(:question_ticket, 3)
          create(:question_ticket, is_hidden: true)
        end

        it 'return instance of ActiveRecord::Relation' do
          expect(subject.includes(:ticket).visible).to be_kind_of(ActiveRecord::Relation)
        end

        it 'load only visible question_tickets' do
          subject.includes(:ticket).visible.each do |q|
            expect(q.ticket.is_hidden).to be_falsey
          end
        end
      end

      describe '#by_visible_service' do
        let(:visible_service) { create(:service) }
        let(:hidden_service) { create(:service, is_hidden: false) }
        let(:visible_questions) { create_list(:question_ticket, 2, ticket: create(:ticket, service: visible_service)) }
        let(:hidden_questions) { create_list(:question_ticket, 2, ticket: create(:ticket, service: hidden_service)) }

        it 'return instance of ActiveRecord::Relation' do
          expect(subject.by_visible_service).to be_kind_of(ActiveRecord::Relation)
        end

        it 'return tickets if service is visible' do
          subject.by_visible_service.each do |q|
            expect(q.service.is_hidden).to be_falsey
          end
        end
      end
    end
  end
end
