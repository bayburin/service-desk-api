require 'rails_helper'

RSpec.describe ServiceResponsibleUserStrategy, type: :model do
  it 'inherits from LocalStrategy class' do
    expect(ServiceResponsibleUserStrategy).to be < LocalStrategy
  end

  describe '#process_searching_user' do
    let!(:user) { create(:user, role_name: :service_responsible) }

    context 'when responsible_user was found' do
      let!(:responsible_user) { create(:responsible_user) }

      it 'returns user with :service_responsible role' do
        expect(subject.process_searching_user(responsible_user.as_json)).to eq user
      end
    end

    context 'when user was not found' do
      it 'returns nil' do
        expect(subject.process_searching_user({ tn: 'test' }.as_json)).to be_nil
      end
    end
  end
end
