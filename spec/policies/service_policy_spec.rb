require 'rails_helper'

RSpec.describe ServicePolicy do
  subject { ServicePolicy }
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }

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

    context 'for user with any another role' do
      subject(:policy_scope) { ServicePolicy::SphinxScope.new(guest, scope).resolve }

      it 'loads all visible services' do
        policy_scope.each do |service|
          expect(service.is_hidden).to be_falsey
        end
      end
    end
  end

  describe '#attributes_for_show' do
    let(:service) { create(:service) }

    context 'for user with service_responsible role' do
      subject(:policy) { ServicePolicy.new(responsible, service).attributes_for_show }

      context 'and when any service belongs to user' do
        before { responsible.services << service }

        it 'sets :serializer attribute' do
          expect(policy.serializer).to eq Api::V1::Services::ServiceResponsibleUserSerializer
        end

        it 'sets :sql_include attribute' do
          expect(policy.sql_include).to eq [:correction, :responsible_users, :tags, answers: :attachments]
        end

        it 'sets :serialize attribute' do
          expect(policy.serialize).to eq ['*', 'tickets.*', 'tickets.answers.attachments', 'tickets.correction.*', 'tickets.correction.answers.attachments']
        end
      end

      context 'and when no one service belongs to user' do
        it 'sets :serializer attribute' do
          expect(policy.serializer).to eq Api::V1::Services::ServiceGuestSerializer
        end

        it 'sets :serialize attribute' do
          expect(policy.serialize).to eq ['category', 'tickets.answers.attachments']
        end
      end
    end

    context 'for user with guest role' do
      it 'sets :serializer attribute' do
        expect(subject.new(guest, service).attributes_for_show.serializer).to eq Api::V1::Services::ServiceGuestSerializer
      end
    end
  end

  describe '#attributes_for_search' do
    let(:service) { create(:service) }

    context 'for user with service_responsible role' do
      subject(:policy) { ServicePolicy.new(responsible, service).attributes_for_search }

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users]
      end
    end

    context 'for user with guest role' do
      subject(:policy) { ServicePolicy.new(guest, service).attributes_for_search }

      it 'does not set any attribute' do
        expect(policy.serializer).to be_nil
        expect(policy.sql_include).to be_empty
        expect(policy.serialize).to be_empty
      end
    end
  end
end
