require 'rails_helper'

RSpec.describe AnswerAttachmentPolicy do
  subject { AnswerAttachmentPolicy }
  let(:guest) { create(:guest_user) }
  let(:manager) { create(:content_manager_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }
  let(:ticket) { create(:ticket) }
  let(:attachment) { create(:answer_attachment, answer: ticket.answers.first) }

  permissions :show? do
    context 'for user with :content_manager role' do
      it 'grants access' do
        expect(subject).to permit(manager, attachment)
      end
    end

    context 'for user with :operator role' do
      it 'grants access' do
        expect(subject).to permit(operator, attachment)
      end
    end

    context 'for user with :service_responsible role' do
      it 'grants access' do
        expect(subject).to permit(responsible, attachment)
      end
    end

    context 'for user with another role' do
      context 'and when ticket is published and visible' do
        it 'grants access' do
          expect(subject).to permit(guest, attachment)
        end
      end

      context 'and when ticket has draft state' do
        before { attachment.ticket.draft_state! }

        it 'denies access' do
          expect(subject).not_to permit(guest, attachment)
        end
      end

      context 'and when ticket invisible' do
        before { attachment.ticket.is_hidden = true }

        it 'denies access' do
          expect(subject).not_to permit(guest, attachment)
        end
      end

      context 'and when service invisible' do
        before { attachment.service.is_hidden = true }

        it 'denies access' do
          expect(subject).not_to permit(guest, attachment)
        end
      end
    end
  end

  permissions :create? do
    it 'calls TicketPolicy#update? method' do
      expect(TicketPolicy).to receive(:new).with(responsible, attachment.ticket).and_call_original
      expect_any_instance_of(TicketPolicy).to receive(:update?)

      subject.new(responsible, attachment).create?
    end
  end

  permissions :destroy? do
    it 'calls TicketPolicy#update? method' do
      expect(TicketPolicy).to receive(:new).with(responsible, attachment.ticket).and_call_original
      expect_any_instance_of(TicketPolicy).to receive(:update?)

      subject.new(responsible, attachment).destroy?
    end
  end
end
