require 'rails_helper'

RSpec.describe ServicePolicy do
  subject { ServicePolicy }
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }
  let(:content_manager) { create(:content_manager_user) }

  permissions :show? do
    context 'for user with :service_responsible role' do
      context 'and when service is hidden' do
        let(:service) { create(:service, is_hidden: true) }

        it 'denies access' do
          expect(subject).not_to permit(responsible, service)
        end

        context 'and when user reponsible for this service' do
          before { responsible.services << service }

          it 'grants access' do
            expect(subject).to permit(responsible, service)
          end
        end

        context 'and when user is in the list of responsible of nested tickets' do
          let!(:ticket) { create(:ticket, is_hidden: true, service: service) }
          before { responsible.tickets << ticket }

          it 'grants access' do
            expect(subject).to permit(responsible, service)
          end
        end
      end

      context 'and when service is not hidden' do
        let!(:service) { create(:service) }

        it 'grants access' do
          expect(subject).to permit(responsible, service)
        end
      end
    end

    context 'for user with :operator role' do
      let(:service) { create(:service, is_hidden: true) }

      it 'grants access' do
        expect(subject).to permit(operator, service)
      end
    end

    context 'for user with :content_manager role' do
      let(:service) { create(:service, is_hidden: true) }

      it 'grants access' do
        expect(subject).to permit(content_manager, service)
      end
    end

    context 'for user with another role' do
      context 'and when service is hidden' do
        let!(:service) { create(:service, is_hidden: true) }

        it 'denies access' do
          expect(subject).not_to permit(guest, service)
        end
      end

      context 'and when service is not hidden' do
        let!(:service) { create(:service) }

        it 'grants access' do
          expect(subject).to permit(guest, service)
        end
      end
    end
  end

  permissions :tickets_ctrl_access? do
    let!(:service) { create(:service) }

    context 'for user with :service_responsible role' do
      context 'and when service belongs to the user' do
        before { responsible.services << service }

        it 'grants access' do
          expect(subject).to permit(responsible, service)
        end
      end

      context 'and when any ticket in service belongs to the user' do
        before { responsible.tickets << service.tickets.first }

        it 'grants access' do
          expect(subject).to permit(responsible, service)
        end
      end

      context 'and when no one ticket in service belongs to the user' do
        it 'denies access' do
          expect(subject).not_to permit(responsible, service)
        end
      end
    end

    context 'for user with :content_manager role' do
      it 'grants access' do
        expect(subject).to permit(content_manager, service)
      end
    end

    context 'for user with another role' do
      it 'denies access' do
        expect(subject).not_to permit(guest, service)
      end
    end
  end

  permissions '.scope' do
    let(:scope) { Service.all }
    let!(:visible_services) { create_list(:service, 2, is_hidden: false) }
    let!(:hidden_service) { create(:service, is_hidden: true) }

    context 'for user with :service_responsible role' do
      subject(:policy_scope) { ServicePolicy::Scope.new(responsible, scope).resolve }

      include_examples 'for #service_scope specs with :service_responsible role'
    end

    context 'for user with :operator role' do
      subject(:policy_scope) { ServicePolicy::Scope.new(operator, scope).resolve }

      it 'loads all services' do
        expect(policy_scope.count).to eq Service.count
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy_scope) { ServicePolicy::Scope.new(content_manager, scope).resolve }

      it 'loads all services' do
        expect(policy_scope.count).to eq Service.count
      end
    end

    context 'for user with any another role' do
      subject(:policy_scope) { ServicePolicy::Scope.new(guest, scope).resolve }

      it 'loads all visible services' do
        policy_scope.each do |service|
          expect(service.is_hidden).to be_falsey
        end
      end
    end
  end

  permissions '.sphinx_scope' do
    let(:scope) { Service.all.to_a }
    let!(:visible_services) { create_list(:service, 2, is_hidden: false) }
    let!(:hidden_service) { create(:service, is_hidden: true) }

    context 'for user with :service_responsible role' do
      subject(:policy_scope) { ServicePolicy::SphinxScope.new(responsible, scope).resolve }

      include_examples 'for #service_scope specs with :service_responsible role'
    end

    context 'for user with :operator role' do
      subject(:policy_scope) { ServicePolicy::SphinxScope.new(operator, scope).resolve }

      it 'loads all services' do
        expect(policy_scope.count).to eq Service.count
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy_scope) { ServicePolicy::SphinxScope.new(content_manager, scope).resolve }

      it 'loads all services' do
        expect(policy_scope.count).to eq Service.count
      end
    end

    context 'for user with any another role' do
      subject(:policy_scope) { ServicePolicy::SphinxScope.new(guest, scope).resolve }

      it 'loads all visible services' do
        policy_scope.each do |service|
          expect(service.is_hidden).to be_falsey
        end
      end
    end
  end

  describe '#attributes_for_index' do
    let(:service) { create(:service) }

    context 'for user with :service_responsible role' do
      subject(:policy) { ServicePolicy.new(responsible, service).attributes_for_index }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Services::ServiceBaseSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:category, :responsible_users, tickets: %i[answers responsible_users]]
      end
    end

    context 'for user with :operator role' do
      subject(:policy) { ServicePolicy.new(operator, service).attributes_for_index }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Services::ServiceResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:category, tickets: :answers]
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy) { ServicePolicy.new(content_manager, service).attributes_for_index }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Services::ServiceResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:category, tickets: :answers]
      end
    end

    context 'for user with any another role' do
      subject(:policy) { ServicePolicy.new(content_manager, service).attributes_for_index }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Services::ServiceResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:category, tickets: :answers]
      end
    end
  end

  describe '#attributes_for_show' do
    let(:service) { create(:service) }

    context 'for user with :service_responsible role' do
      subject(:policy) { ServicePolicy.new(responsible, service).attributes_for_show }

      context 'and when any service belongs to user' do
        before { responsible.services << service }

        it 'sets :serializer attribute' do
          expect(policy.serializer).to eq Api::V1::Services::ServiceResponsibleUserSerializer
        end

        it 'sets :sql_include attribute' do
          expect(policy.sql_include).to eq [ticket: %i[responsible_users tags service], answers: :attachments, correction: [ticket: %i[responsible_users tags service], answers: :attachments]]
        end

        it 'sets :serialize attribute' do
          expect(policy.serialize).to eq ['*', 'questions.ticket.*', 'questions.answers.attachments', 'questions.correction.*', 'questions.correction.answers.attachments', 'questions.correction.ticket.responsible_users', 'questions.correction.ticket.tags']
        end
      end

      context 'and when no one service belongs to user' do
        it 'sets :serializer attribute' do
          expect(policy.serializer).to eq Api::V1::Services::ServiceGuestSerializer
        end

        it 'sets :serialize attribute' do
          expect(policy.serialize).to eq ['category', 'questions.answers.attachments', 'questions.*']
        end
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy) { ServicePolicy.new(content_manager, service).attributes_for_show }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Services::ServiceResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: %i[responsible_users tags service], answers: :attachments, correction: [ticket: %i[responsible_users tags service], answers: :attachments]]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['*', 'questions.ticket.*', 'questions.answers.attachments', 'questions.correction.*', 'questions.correction.answers.attachments', 'questions.correction.ticket.responsible_users', 'questions.correction.ticket.tags']
      end
    end

    context 'for user with :operator role' do
      subject(:policy) { ServicePolicy.new(operator, service).attributes_for_show }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Services::ServiceResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [ticket: %i[service responsible_users]]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['category', 'questions.answers.attachments', 'questions.ticket.responsible_users', 'questions.ticket.service']
      end
    end

    context 'for user with any another role' do
      subject(:policy) { ServicePolicy.new(guest, service).attributes_for_show }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Services::ServiceGuestSerializer
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['category', 'questions.answers.attachments', 'questions.*']
      end
    end
  end

  describe '#attributes_for_search' do
    let(:service) { create(:service) }

    context 'for user with :service_responsible role' do
      subject(:policy) { ServicePolicy.new(responsible, service).attributes_for_search }

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users']
      end
    end

    context 'for user with any another role' do
      subject(:policy) { ServicePolicy.new(guest, service).attributes_for_search }

      it 'does not set any attribute' do
        expect(policy.serializer).to be_nil
        expect(policy.sql_include).to be_empty
        expect(policy.serialize).to be_empty
      end
    end
  end
end
