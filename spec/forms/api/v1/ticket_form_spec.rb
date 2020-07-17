require 'rails_helper'

module Api
  module V1
    RSpec.describe TicketForm, type: :model do
      let(:params) do
        {
          tags: [attributes_for(:tag)],
          responsible_users: [attributes_for(:responsible_user)]
        }
      end
      subject { described_class.new(Ticket.new) }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:identity) }

      it 'add error if any of tags collection is invalid' do
        allow_any_instance_of(TagForm).to receive(:valid?).and_return(false)
        subject.validate(params)

        expect(subject.errors.details[:base]).to include(error: 'Проверьте корректность введенных тегов')
      end

      it 'add error if any of responsible_users collection is invalid' do
        allow_any_instance_of(ResponsibleUserForm).to receive(:valid?).and_return(false)
        subject.validate(params)

        expect(subject.errors.details[:base]).to include(error: 'Проверьте корректность ответственных')
      end

      describe '#populate_collections' do
        let(:tags) { create_list(:tag, 3) }
        let(:ticket) { create(:ticket, tags: tags) }
        let(:saved_tag) { tags.first }
        let(:params) { { tags: [saved_tag.as_json.symbolize_keys] } }
        subject { described_class.new(ticket) }
        before { subject.populate_collections(params) }

        it 'delete tag from tags collection if it does not exist' do
          expect(subject.tags.count).to eq 1
        end

        it 'save only received tag' do
          expect(subject.tags.first.id).to eq saved_tag.id
        end
      end

      describe 'populate_tags!' do
        let(:tags) { create_list(:tag, 2) }
        let(:tag_by_id) { tags.first }
        let(:tag_by_name) { tags.last }
        let(:params) { { tags: [{ id: tag_by_id.id }, { name: tag_by_name.name }] } }

        context 'when tag was added' do
          before { subject.validate(params) }

          it 'add tag to collection if find it by id' do
            expect(subject.tags.any? { |tag| tag.id == tag_by_id.id }).to be_truthy
          end

          it 'add tag to collection if find it by name' do
            expect(subject.tags.any? { |tag| tag.id == tag_by_name.id }).to be_truthy
          end
        end

        context 'when tag already in collection' do
          let(:ticket) { create(:ticket, tags: tags) }
          let(:params) { { tags: tags.as_json.map(&:symbolize_keys) } }
          subject { described_class.new(ticket) }

          it 'does not add duplicate tag' do
            subject.validate(params)

            expect(subject.tags.count).to eq 2
          end
        end
      end

      describe 'populate_responsible_users!' do
        let(:responsible_users) { create_list(:responsible_user, 2) }
        let!(:ticket) { create(:ticket, responsible_users: responsible_users) }
        let(:new_user) { attributes_for(:responsible_user, responseable: nil) }
        let(:destroy_user) do
          user = responsible_users.first.as_json
          user[:_destroy] = true
          user
        end
        let(:user_params) do
          [
            destroy_user,
            responsible_users.last.as_json,
            new_user
          ].map(&:symbolize_keys)
        end
        let(:params) { { responsible_users: user_params } }
        subject { described_class.new(ticket) }
        before { subject.validate(params) }

        it 'change count of responsible_users collection' do
          expect(subject.responsible_users.count).to eq 2
        end

        it 'add a new responsible_user' do
          expect(subject.responsible_users.any? { |u| u.tn == new_user[:tn] }).to be_truthy
        end

        it 'remove user with _destroy attribute' do
          expect(subject.responsible_users.any? { |u| u.tn == destroy_user[:tn] }).to be_falsey
        end
      end
    end
  end
end
