require 'rails_helper'

RSpec.describe AppPolicy do
  subject { AppPolicy }

  permissions '.scope' do
    let(:user) { build(:user) }
    let(:scope) { double(:scope) }
    subject(:policy_scope) { AppPolicy::Scope.new(user, scope).resolve }

    it 'loads only apps in which user is creator' do
      expect(scope).to receive(:where).with(user_tn: user.tn)

      policy_scope
    end
  end

  permissions :create? do
    context 'when tn is matched' do
      let(:user) { create(:user) }
      let(:app) { build(:app, user: user) }

      it 'grant access' do
        expect(subject).to permit(user, app)
      end
    end

    context 'when tn is not matched' do
      let(:app) { build(:app) }
      let(:user) { build(:user, tn: -1234) }

      it 'deny access' do
        expect(subject).not_to permit(user, app)
      end
    end
  end

  permissions :update? do
    context 'when tn is matched' do
      let(:user) { create(:user) }
      let(:app) { build(:app, user: user) }

      it 'grant access' do
        expect(subject).to permit(user, app)
      end
    end

    context 'when tn is not matched' do
      let(:app) { build(:app) }
      let(:user) { build(:user, tn: -1234) }

      it 'deny access' do
        expect(subject).not_to permit(user, app)
      end
    end
  end
end
