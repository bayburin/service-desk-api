require 'rails_helper'

RSpec.describe CasePolicy do
  subject { CasePolicy }

  permissions :create? do
    context 'when tn is matched' do
      let(:kase) { build(:case) }
      let(:user) { build(:user) }

      it 'grant access' do
        expect(subject).to permit(user, kase)
      end
    end

    context 'when tn is not matched' do
      let(:kase) { build(:case) }
      let(:user) { build(:user, tn: 1234) }

      it 'deny access' do
        expect(subject).not_to permit(user, kase)
      end
    end
  end
end
