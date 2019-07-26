require 'rails_helper'

RSpec.describe CasePolicy do
  subject { CasePolicy }

  permissions '.scope' do
    let(:user) { build(:user) }
    let(:scope) { double(:scope) }
    subject(:policy_scope) { CasePolicy::Scope.new(user, scope).resolve }

    it 'loads only cases in which user is creator' do
      expect(scope).to receive(:where).with(user_tn: user.tn)

      policy_scope
    end
  end

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

  permissions :update? do
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
