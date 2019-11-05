require 'rails_helper'

RSpec.describe TicketPolicy do
  subject { TicketPolicy }
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }
  let(:content_manager) { create(:content_manager_user) }
  let(:service) { create(:service) }

  permissions :update? do
    let(:ticket) { create(:ticket, service: service) }

    context 'for user with :service_responsible role' do
      context 'and when ticket belongs to the user' do
        before { responsible.tickets << ticket }

        it 'grants access' do
          expect(subject).to permit(responsible, ticket)
        end
      end

      context 'and when service belongs to the user' do
        before { responsible.services << service }

        it 'grants access' do
          expect(subject).to permit(responsible, ticket)
        end
      end

      context 'and when ticket and service not belongs to the user' do
        before { responsible.tickets << service.tickets.first }

        it 'denies access' do
          expect(subject).not_to permit(responsible, ticket)
        end
      end
    end

    context 'for user with :content_manager role' do
      it 'grants access' do
        expect(subject).to permit(content_manager, ticket)
      end
    end

    context 'for user with another role' do
      it 'denies access' do
        expect(subject).not_to permit(guest, ticket)
      end
    end
  end

  permissions :raise_rating? do
    context 'when ticket has :published state' do
      let(:ticket) { create(:ticket, state: :published) }

      it 'grants access' do
        expect(subject).to permit(guest, ticket)
      end
    end

    context 'when ticket has :draft state' do
      let(:ticket) { create(:ticket, state: :draft) }

      it 'denies access' do
        expect(subject).not_to permit(guest, ticket)
      end
    end
  end

  # permissions :show? do
  #   context 'for user with :service_responsible role' do
  #     context 'and when ticket is hidden' do
  #       let(:ticket) { create(:ticket, is_hidden: true) }

  #       it 'denies access' do
  #         expect(subject).not_to permit(responsible, ticket)
  #       end

  #       context 'and when user reponsible for this ticket' do
  #         before { responsible.tickets << ticket }

  #         it 'grants access' do
  #           expect(subject).to permit(responsible, ticket)
  #         end
  #       end

  #       context 'and when user responsible for parent service' do
  #         before do
  #           ticket.service = service
  #           responsible.services << service
  #         end

  #         it 'grants access' do
  #           expect(subject).to permit(responsible, ticket)
  #         end
  #       end

  #       context 'and when user responsible for another ticket from the same service' do
  #         let(:another_ticket) { create(:ticket, service: service) }
  #         before do
  #           responsible.tickets << another_ticket
  #           ticket.service = service
  #         end

  #         it 'grants access' do
  #           expect(subject).to permit(responsible, ticket)
  #         end
  #       end
  #     end

  #     context 'and when ticket is not hidden' do
  #       let(:ticket) { create(:ticket) }

  #       it 'grants access' do
  #         expect(subject).to permit(responsible, ticket)
  #       end

  #       context 'and when parent service is hidden' do
  #         before do
  #           service.tickets << ticket
  #           service.is_hidden = true
  #         end

  #         it 'denies access' do
  #           expect(subject).not_to permit(responsible, ticket)
  #         end

  #         context 'and when ticket belongs to user' do
  #           before { responsible.tickets << ticket }

  #           it 'grants access' do
  #             expect(subject).to permit(responsible, ticket)
  #           end
  #         end
  #       end

  #       context 'and when ticket has :draft state' do
  #         before { ticket.state = :draft }

  #         it 'denies access' do
  #           expect(subject).not_to permit(responsible, ticket)
  #         end

  #         context 'and when ticket belongs to user' do
  #           before { responsible.tickets << ticket }

  #           it 'grants access' do
  #             expect(subject).to permit(responsible, ticket)
  #           end
  #         end
  #       end
  #     end
  #   end

  #   context 'for user with another role' do
  #     context 'and when ticket is hidden' do
  #       let(:ticket) { create(:ticket, is_hidden: true) }

  #       it 'denies access' do
  #         expect(subject).not_to permit(guest, ticket)
  #       end
  #     end

  #     context 'and when ticket is not hidden' do
  #       let!(:ticket) { create(:ticket) }

  #       it 'grants access' do
  #         expect(subject).to permit(guest, ticket)
  #       end
  #     end

  #     context 'and when service is hidden' do
  #       let(:ticket) { service.tickets.first }
  #       before { service.is_hidden = true }

  #       it 'denies access' do
  #         expect(subject).not_to permit(guest, ticket)
  #       end
  #     end

  #     context 'and when ticket has :draft state' do
  #       let(:ticket) { create(:ticket, state: :draft) }

  #       it 'denies access' do
  #         expect(subject).not_to permit(guest, ticket)
  #       end
  #     end
  #   end
  # end

  # permissions :create? do
  #   let(:ticket) { build(:ticket, state: :draft, service: service) }

  #   context 'for user with :service_responsible role' do
  #     it 'denies access' do
  #       expect(subject).not_to permit(guest, ticket)
  #     end

  #     context 'when service belongs to user' do
  #       before { responsible.services << service }

  #       it 'grants access' do
  #         expect(subject).to permit(responsible, ticket)
  #       end
  #     end

  #     context 'when any ticket in service belongs to user' do
  #       before { responsible.tickets << service.tickets.first }

  #       it 'grants access' do
  #         expect(subject).to permit(responsible, ticket)
  #       end
  #     end
  #   end

  #   context 'for user with another role' do
  #     it 'denies access' do
  #       expect(subject).not_to permit(guest, ticket)
  #     end
  #   end
  # end

  permissions '.scope' do
    let(:scope) { service.tickets }
    let!(:hidden_ticket) { create(:ticket, is_hidden: true, service: service) }
    let!(:draft_ticet) { create(:ticket, state: :draft, service: service) }

    context 'for user with :service_responsible role' do
      let!(:ticket) { service.tickets.first }
      let!(:draft_ticket) { create(:ticket, is_hidden: false, state: :draft, service: service) }
      let!(:extra_service) { create(:service) }
      let!(:extra_ticket) { create(:ticket, service: extra_service) }
      subject(:policy_scope) { TicketPolicy::Scope.new(responsible, scope).resolve_by(service) }

      it 'loads only visible and published tickets' do
        expect(policy_scope.length).to eq(2)
        expect(policy_scope).to include(ticket)
        expect(policy_scope).not_to include(hidden_ticket)
        expect(policy_scope).not_to include(draft_ticket)
        expect(policy_scope).not_to include(extra_ticket)
      end

      context 'and when one of ticket in service belongs to user' do
        before { responsible.tickets << ticket }

        it 'loads all published tickets in current service' do
          expect(policy_scope).to include(ticket)
          expect(policy_scope).to include(hidden_ticket)
          expect(policy_scope).not_to include(extra_ticket)
          policy_scope.each do |ticket|
            expect(ticket.published_state?).to be_truthy
          end
        end
      end

      context 'and when service belongs to user' do
        before { responsible.services << service }

        it 'loads all published tickets' do
          policy_scope.each do |ticket|
            # expect(ticket.is_hidden).to be_falsey
            expect(ticket.state).to eq 'published'
          end
        end
      end
    end

    context 'for user with any another role' do
      subject(:policy_scope) { TicketPolicy::Scope.new(guest, scope).resolve_by(service) }

      it 'loads only visible and published tickets' do
        policy_scope.each do |ticket|
          expect(ticket.published_state?).to be_truthy
          expect(ticket.is_hidden).to be_falsy
        end
      end
    end
  end

  permissions '.sphinx_scope' do
    let(:scope) { service.tickets.to_a }
    let!(:hidden_ticket) { create(:ticket, is_hidden: true, service: service) }
    let!(:draft_ticket) { create(:ticket, state: :draft, service: service) }

    context 'for user with :service_responsible role' do
      let(:extra_service) { create(:service) }
      let!(:ticket) { create(:ticket, service: service) }

      subject(:policy_scope) { TicketPolicy::SphinxScope.new(responsible, scope).resolve }

      it 'loads only published tickets' do
        expect(policy_scope).not_to include(draft_ticket)
      end

      it 'loads all visible tickets' do
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

    context 'for user with :operator role' do
      subject(:policy_scope) { TicketPolicy::SphinxScope.new(operator, scope).resolve }

      it 'loads all published tickets' do
        policy_scope.each do |ticket|
          expect(ticket.published_state?).to be_truthy
        end
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy_scope) { TicketPolicy::SphinxScope.new(content_manager, scope).resolve }

      it 'loads all published tickets' do
        policy_scope.each do |ticket|
          expect(ticket.published_state?).to be_truthy
        end
      end
    end

    context 'for user with any another role' do
      subject(:policy_scope) { TicketPolicy::SphinxScope.new(guest, scope).resolve }

      it 'loads only visible tickets' do
        policy_scope.each do |ticket|
          expect(ticket.is_hidden).to be_falsey
        end
      end

      it 'loads tickets only with published state' do
        policy_scope.each do |ticket|
          expect(ticket.published_state?).to be_truthy
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
  end

  describe '#attributes_for_show' do
    let(:ticket) { service.tickets.first }

    subject(:policy) { TicketPolicy.new(responsible, ticket).attributes_for_show }

    it 'sets :serializer attribute' do
      expect(policy.serializer).to eq Api::V1::Tickets::TicketResponsibleUserSerializer
    end

    it 'sets :serialize attribute' do
      expect(policy.serialize).to eq ['correction', 'responsible_users', 'tags', 'answers.attachments,correction.*', 'correction.answers.attachments']
    end
  end

  describe '#attributes_for_search' do
    let(:ticket) { service.tickets.first }

    context 'for user with :service_responsible role' do
      subject(:policy) { TicketPolicy.new(responsible, ticket).attributes_for_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Tickets::TicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, service: :responsible_users]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'service.responsible_users']
      end
    end

    context 'for user with :operator role' do
      subject(:policy) { TicketPolicy.new(operator, ticket).attributes_for_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Tickets::TicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, service: :responsible_users]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'service.responsible_users']
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy) { TicketPolicy.new(content_manager, ticket).attributes_for_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Tickets::TicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, service: :responsible_users]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'service.responsible_users']
      end
    end

    context 'for user with any another role' do
      subject(:policy) { TicketPolicy.new(guest, ticket).attributes_for_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Tickets::TicketGuestSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:service]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['service']
      end
    end
  end

  describe '#attributes_for_deep_search' do
    let(:ticket) { service.tickets.first }

    context 'for user with :service_responsible role' do
      subject(:policy) { TicketPolicy.new(responsible, ticket).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Tickets::TicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, service: :responsible_users, answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with :operator role' do
      subject(:policy) { TicketPolicy.new(operator, ticket).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Tickets::TicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, service: :responsible_users, answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with :content_manager role' do
      subject(:policy) { TicketPolicy.new(content_manager, ticket).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Tickets::TicketResponsibleUserSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:responsible_users, service: :responsible_users, answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['responsible_users', 'service.responsible_users', 'answers.attachments']
      end
    end

    context 'for user with any another role' do
      subject(:policy) { TicketPolicy.new(guest, ticket).attributes_for_deep_search }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Tickets::TicketGuestSerializer
      end

      it 'sets :sql_include attribute' do
        expect(policy.sql_include).to eq [:service, answers: :attachments]
      end

      it 'sets :serialize attribute' do
        expect(policy.serialize).to eq ['answers.attachments', 'service']
      end
    end
  end
end
