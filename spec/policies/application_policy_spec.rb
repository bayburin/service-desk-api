require 'rails_helper'

RSpec.describe ApplicationPolicy do
  permissions '.scope' do
    let(:user) { build(:user) }
    let(:scope) { double(:scope) }
    subject(:policy_scope) { ApplicationPolicy::Scope.new(user, scope).resolve }

    it 'runs loads only apps in which user is creator' do
      expect(policy_scope).to eq scope
    end
  end
end
