require 'rails_helper'

RSpec.describe ServiceResponsibleUserStrategy, type: :model do
  it 'inherits from LocalStrategy class' do
    expect(ServiceResponsibleUserStrategy).to be < LocalStrategy
  end

  describe '#process_checking_access' do
    let!(:user) { create(:user, role_name: :service_responsible) }

    context 'when responsible_user was found' do
      let!(:responsible_user) { create(:responsible_user) }

      it 'returns user with :service_responsible role' do
        expect(subject.process_checking_access(responsible_user.as_json)).to eq user
      end
    end

    context 'when user was not found' do
      it 'returns nil' do
        expect(subject.process_checking_access({ tn: 'test' }.as_json)).to be_nil
      end
    end
  end
end
