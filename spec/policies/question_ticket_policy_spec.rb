require 'rails_helper'

RSpec.describe QuestionTicketPolicy do
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }
  let(:content_manager) { create(:content_manager_user) }
  let(:service) { create(:service) }
  subject { QuestionTicketPolicy }

  describe '#attributes_for_deep_search' do
    let(:question) { service.question_tickets.first }

    context 'for user with :service_responsible role' do
      subject(:policy) { QuestionTicketPolicy.new(responsible, question).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::QuestionTickets::QuestionTicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, ticket: { service: :responsible_users }, answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'ticket.service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with :operator role' do
      subject(:policy) { QuestionTicketPolicy.new(operator, question).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::QuestionTickets::QuestionTicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, ticket: { service: :responsible_users }, answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'ticket.service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy) { QuestionTicketPolicy.new(content_manager, question).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::QuestionTickets::QuestionTicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, ticket: { service: :responsible_users }, answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'ticket.service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with any another role' do
      subject(:policy) { QuestionTicketPolicy.new(guest, question).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::QuestionTickets::QuestionTicketGuestSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: :service, answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['answers.attachments', 'ticket.service']
      end
    end
  end
end
