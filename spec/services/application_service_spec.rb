require 'rails_helper'

RSpec.describe ApplicationService, type: :model do
  let!(:auth_center_token) { create(:auth_center_token) }
  let!(:doorkeeper_token) { create(:doorkeeper_token) }

  describe '#auth_center_token' do
    before { allow(subject).to receive(:doorkeeper_token).and_return(doorkeeper_token) }

    it 'returns auth_center_token' do
      expect(subject.auth_center_token).to eq auth_center_token
    end
  end
end
