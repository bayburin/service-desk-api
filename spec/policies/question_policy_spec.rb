require 'rails_helper'

RSpec.describe QuestionPolicy do
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }
  let(:content_manager) { create(:content_manager_user) }
  let(:service) { create(:service) }
  subject { QuestionPolicy }

  describe '#attributes_for_search' do
    let(:question) { service.questions.first }

    context 'for user with :service_responsible role' do
      subject(:policy) { QuestionPolicy.new(responsible, question).attributes_for_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Questions::QuestionResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: [:responsible_users, service: :responsible_users]]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['ticket.responsible_users', 'ticket.service.responsible_users']
      end
    end

    context 'for user with :operator role' do
      subject(:policy) { QuestionPolicy.new(operator, question).attributes_for_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Questions::QuestionResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: [:responsible_users, service: :responsible_users]]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['ticket.responsible_users', 'ticket.service.responsible_users']
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy) { QuestionPolicy.new(content_manager, question).attributes_for_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Questions::QuestionResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: [:responsible_users, service: :responsible_users]]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['ticket.responsible_users', 'ticket.service.responsible_users']
      end
    end

    context 'for user with any another role' do
      subject(:policy) { QuestionPolicy.new(guest, question).attributes_for_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Questions::QuestionGuestSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: :service]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['ticket.service']
      end
    end
  end

  describe '#attributes_for_deep_search' do
    let(:question) { service.questions.first }

    context 'for user with :service_responsible role' do
      subject(:policy) { QuestionPolicy.new(responsible, question).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Questions::QuestionResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: [:responsible_users, service: :responsible_users], answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['ticket.responsible_users', 'ticket.service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with :operator role' do
      subject(:policy) { QuestionPolicy.new(operator, question).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Questions::QuestionResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: [:responsible_users, service: :responsible_users], answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['ticket.responsible_users', 'ticket.service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy) { QuestionPolicy.new(content_manager, question).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Questions::QuestionResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: [:responsible_users, service: :responsible_users], answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['ticket.responsible_users', 'ticket.service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with any another role' do
      subject(:policy) { QuestionPolicy.new(guest, question).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Questions::QuestionGuestSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: :service]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['answers.attachments', 'ticket.service']
      end
    end
  end

  describe '#attributes_for_show' do
    let(:question) { service.tickets.first }
    subject(:policy) { QuestionPolicy.new(responsible, question).attributes_for_show }

    it 'sets :serializer attribute' do
      expect(policy.serializer).to eq Api::V1::Questions::QuestionResponsibleUserSerializer
    end

    it 'sets :sql_include attribute' do
      expect(policy.sql_include).to eq [:correction, ticket: %i[service responsible_users tags ticket_tags], answers: :attachments]
    end

    it 'sets :serialize attribute' do
      expect(policy.serialize).to eq [
        'correction.*', 'correction.ticket.responsible_users', 'correction.ticket.service', 'correction.ticket.tags',
        'correction.answers.attachments', 'ticket.responsible_users', 'ticket.tags', 'ticket.service', 'answers.attachments'
      ]
    end
  end
end
