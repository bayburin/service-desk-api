require 'rails_helper'

RSpec.describe UserPolicy do
  subject { UserPolicy }
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }
  let(:content_manager) { create(:content_manager_user) }

  permissions :responsible_user_access? do
    context 'for user with :content_manager role' do
      it 'grants access' do
        expect(subject).to permit(content_manager)
      end
    end

    context 'for user with :operator role' do
      it 'grants access' do
        expect(subject).to permit(operator)
      end
    end

    context 'for user with :service_responsible role' do
      it 'grants access' do
        expect(subject).to permit(responsible)
      end
    end

    context 'for user with another role' do
      it 'denies access' do
        expect(subject).not_to permit(guest)
      end
    end
  end
end
