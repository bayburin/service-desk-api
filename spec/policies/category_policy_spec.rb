require 'rails_helper'

RSpec.describe CategoryPolicy do
  subject { CategoryPolicy }
  let(:guest) { create(:guest_user) }
  let(:responsible) { create(:service_responsible_user) }
  let(:operator) { create(:operator_user) }
  let(:category) { create(:category) }

  describe '#attributes_for_show' do
    it 'returns instance of PolicyAttributes class' do
      expect(subject.new(guest, category).attributes_for_show).to be_a PolicyAttributes
    end

    context 'for user with service_responsible role' do
      subject(:policy) { CategoryPolicy.new(responsible, category).attributes_for_show }

      context 'and when any service belongs to user' do
        before { responsible.services << category.services.first }

        it 'sets :serializer attribute' do
          expect(policy.serializer).to eq Api::V1::Categories::CategoryResponsibleUserSerializer
        end
      end

      context 'and when no one service belongs to user' do
        it 'sets :serializer attribute' do
          expect(policy.serializer).to eq Api::V1::Categories::CategoryGuestSerializer
        end
      end
    end

    context 'for user with guest role' do
      subject(:policy) { CategoryPolicy.new(guest, category).attributes_for_show }

      it 'sets :serializer attribute' do
        expect(policy.serializer).to eq Api::V1::Categories::CategoryGuestSerializer
      end
    end
  end
end
