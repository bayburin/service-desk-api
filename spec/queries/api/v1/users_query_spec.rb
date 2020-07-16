require 'rails_helper'

module Api
  module V1
    RSpec.describe UsersQuery, type: :model do
      let!(:guest) { create(:guest_user, id_tn: 1, tn: 1) }
      let!(:operator) { create(:operator_user, id_tn: 2, tn: 2) }
      let!(:manager) { create(:content_manager_user, id_tn: 3, tn: 3) }
      let!(:sec_manager) { create(:content_manager_user, id_tn: 4, tn: 4) }
      let(:role) { Role.find_by(name: :content_manager) }
      let(:scope) { User.where(tn: 321) }
      subject { UsersQuery.new }

      it 'inherits from ApplicationQuery class' do
        expect(described_class).to be < ApplicationQuery
      end

      context 'when scope exists' do
        subject { UsersQuery.new(scope) }

        it 'use current scope' do
          expect(subject.scope).to eq scope
        end
      end

      context 'when scope does not exist' do
        it 'creates scope' do
          expect(subject.scope).to eq User.all
        end
      end

      describe '#managers' do
        it 'loads all users with :manager role' do
          expect(subject.managers.count).to eq 2

          subject.managers.each { |user| expect(user.role).to eq role }
        end
      end
    end
  end
end
