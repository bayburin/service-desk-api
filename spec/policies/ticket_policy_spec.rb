require 'rails_helper'

RSpec.describe TicketPolicy do
  subject { TicketPolicy }
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }
  let(:service) { create(:service) }

  permissions :show? do
    context 'for user with :guest role' do
      context 'and when ticket is hidden' do
        let(:ticket) { create(:ticket, is_hidden: true) }

        it 'denies access' do
          expect(subject).not_to permit(guest, ticket)
        end
      end

      context 'and when ticket is not hidden' do
        let!(:ticket) { create(:ticket) }

        it 'grants access' do
          expect(subject).to permit(guest, ticket)
        end
      end

      context 'and when service is hidden' do
        let(:ticket) { service.tickets.first }
        before { service.is_hidden = true }

        it 'denies access' do
          expect(subject).not_to permit(guest, ticket)
        end
      end
    end

    context 'for user with :service_responsible role' do
      context 'and when ticket is hidden' do
        let(:ticket) { create(:ticket, is_hidden: true) }

        it 'denies access' do
          expect(subject).not_to permit(responsible, ticket)
        end

        context 'and when user reponsible for this ticket' do
          before { responsible.tickets << ticket }

          it 'grants access' do
            expect(subject).to permit(responsible, ticket)
          end
        end

        context 'and when user responsible for parent service' do
          before do
            ticket.service = service
            responsible.services << service
          end

          it 'grants access' do
            expect(subject).to permit(responsible, ticket)
          end
        end

        context 'and when user responsible for another ticket from the same service' do
          let(:another_ticket) { create(:ticket, service: service) }
          before do
            responsible.tickets << another_ticket
            ticket.service = service
          end

          it 'grants access' do
            expect(subject).to permit(responsible, ticket)
          end
        end
      end

      context 'and when ticket is not hidden' do
        let(:ticket) { create(:ticket) }

        it 'grants access' do
          expect(subject).to permit(responsible, ticket)
        end

        context 'and when parent service is hidden' do
          before do
            service.tickets << ticket
            service.is_hidden = true
          end

          it 'denies access' do
            expect(subject).not_to permit(responsible, ticket)
          end

          context 'and user responsible for ticket' do
            before { responsible.tickets << ticket }

            it 'grants access' do
              expect(subject).to permit(responsible, ticket)
            end
          end
        end
      end
    end

    context 'for user with another role' do
      let(:ticket) { service.tickets.first }

      it 'grants access' do
        expect(subject).to permit(operator, ticket)
      end
    end
  end

  permissions '.scope' do
    let(:scope) { service.tickets }
    let!(:hidden_ticket) { create(:ticket, is_hidden: true, service: service) }

    context 'for user with :guest role' do
      subject(:policy_scope) { TicketPolicy::Scope.new(guest, scope).resolve }

      it 'loads all visible tickets' do
        expect(policy_scope.length).to eq 2
        policy_scope.each do |ticket|
          expect(ticket.is_hidden).to be_falsey
        end
      end
    end

    context 'for user with :service_responsible role' do
      let!(:ticket) { create(:ticket, is_hidden: true, service: service) }
      let!(:extra_service) { create(:service) }
      let!(:extra_ticket) { create(:ticket, service: extra_service) }
      subject(:policy_scope) { TicketPolicy::Scope.new(responsible, scope).resolve(service) }
      before { responsible.tickets << ticket }

      it 'loads all tickets in current service' do
        expect(policy_scope).to include(ticket)
        expect(policy_scope).to include(hidden_ticket)
        expect(policy_scope).not_to include(extra_ticket)
      end
    end

    context 'for user with any another role' do
      subject(:policy_scope) { TicketPolicy::Scope.new(operator, scope).resolve }

      it 'loads all services' do
        expect(policy_scope.length).to eq 3
      end
    end
  end

  permissions '.sphinx_scope' do
    let(:scope) { service.tickets.to_a }
    let!(:hidden_ticket) { create(:ticket, is_hidden: true, service: service) }

    context 'for user with :guest role' do
      subject(:policy_scope) { TicketPolicy::SphinxScope.new(guest, scope).resolve }

      it 'loads only visible tickets' do
        policy_scope.each do |ticket|
          expect(ticket.is_hidden).to be_falsey
        end
      end

      context 'when service is hidden' do
        subject(:policy_scope) { TicketPolicy::SphinxScope.new(guest, scope).resolve }
        before { service.is_hidden = true }

        it 'does not load tickets' do
          expect(policy_scope).to be_empty
        end
      end
    end

    context 'for user with :service_responsible role' do
      let(:extra_service) { create(:service) }
      let!(:ticket) { create(:ticket, service: service) }

      subject(:policy_scope) { TicketPolicy::SphinxScope.new(responsible, scope).resolve }

      it 'loads all visible tickets' do
        # expect(policy_scope.length).to eq 3
        expect(policy_scope).to include(ticket)
        expect(policy_scope).not_to include(hidden_ticket)
      end

      context 'when service is hidden' do
        before { service.is_hidden = true }

        it 'does not load ticket' do
          expect(policy_scope).not_to include(ticket)
        end
      end

      context 'when ticket belongs to user' do
        let(:extra_ticket) { create(:ticket, is_hidden: true, service: service) }
        before { responsible.tickets << extra_ticket }

        it 'loads ticket' do
          expect(policy_scope).to include(extra_ticket)
        end
      end

      context 'when service belongs to user' do
        before { responsible.services << service }

        it 'loads ticket' do
          expect(policy_scope).to include(hidden_ticket)
        end
      end

      context 'when another ticket in service belongs to user' do
        let!(:extra_ticket) { create(:ticket, is_hidden: true, service: service) }
        before { responsible.tickets << extra_ticket }

        it 'loads all tickets from service' do
          expect(policy_scope).to include(hidden_ticket)
        end
      end
    end

    context 'for user with any another role' do
      subject(:policy_scope) { TicketPolicy::SphinxScope.new(operator, scope).resolve }

      it 'loads all services' do
        expect(policy_scope.length).to eq 3
      end
    end
  end
end
