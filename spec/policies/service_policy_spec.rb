require 'rails_helper'

RSpec.describe ServicePolicy do
  subject { ServicePolicy }
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }

  permissions :show? do
    context 'for user with :guest role' do
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
      let(:service) { create(:service, is_hidden: true) }

      it 'grants access' do
        expect(subject).to permit(operator, service)
      end
    end
  end

  permissions '.scope' do
    let(:scope) { Service.all }
    let!(:visible_services) { create_list(:service, 2, is_hidden: false) }
    let!(:hidden_service) { create(:service, is_hidden: true) }

    context 'for user with :guest role' do
      subject(:policy_scope) { ServicePolicy::Scope.new(guest, scope).resolve }

      it 'loads all visible services' do
        policy_scope.each do |service|
          expect(service.is_hidden).to be_falsey
        end
      end
    end

    context 'for user with :service_responsible role' do
      subject(:policy_scope) { ServicePolicy::Scope.new(responsible, scope).resolve }

      include_examples 'for #service_scope specs with :service_responsible role'
    end

    context 'for user with any another role' do
      subject(:policy_scope) { ServicePolicy::Scope.new(operator, scope).resolve }

      it 'loads all services' do
        expect(policy_scope.length).to eq 3
      end
    end
  end

  permissions '.sphinx_scope' do
    let(:scope) { Service.all.to_a }
    let!(:visible_services) { create_list(:service, 2, is_hidden: false) }
    let!(:hidden_service) { create(:service, is_hidden: true) }

    context 'for user with :guest role' do
      subject(:policy_scope) { ServicePolicy::SphinxScope.new(guest, scope).resolve }

      it 'loads all visible services' do
        policy_scope.each do |service|
          expect(service.is_hidden).to be_falsey
        end
      end
    end

    context 'for user with :service_responsible role' do
      subject(:policy_scope) { ServicePolicy::SphinxScope.new(responsible, scope).resolve }

      include_examples 'for #service_scope specs with :service_responsible role'
    end

    context 'for user with any another role' do
      subject(:policy_scope) { ServicePolicy::Scope.new(operator, scope).resolve }

      it 'loads all services' do
        expect(policy_scope.length).to eq 3
      end
    end
  end
end
