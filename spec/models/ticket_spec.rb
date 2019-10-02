require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:ticket_tags).dependent(:destroy) }
  it { is_expected.to have_many(:tags).through(:ticket_tags) }
  it { is_expected.to have_many(:responsible_users).dependent(:destroy) }
  it { is_expected.to have_one(:correction).class_name('Ticket').with_foreign_key(:original_id).dependent(:nullify) }
  it { is_expected.to belong_to(:service) }
  it { is_expected.to belong_to(:original).class_name('Ticket').optional }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.not_to validate_presence_of(:answers) }

  context 'when ticket has published_state' do
    before { subject.state = :published }

    it { is_expected.to validate_presence_of(:answers) }
  end

  it 'includes Associatable module' do
    expect(subject.singleton_class.ancestors).to include(Associatable)
  end

  it 'includes Belongable module' do
    expect(subject.singleton_class.ancestors).to include(Belongable)
  end

  describe '#calculate_popularity' do
    let!(:popularity) { subject.popularity + 1 }

    it 'increases popularity' do
      expect(subject.calculate_popularity).to eq popularity
    end
  end

  describe '#tags_attributes' do
    let(:new_tag_attr) { attributes_for(:tag) }
    let!(:existing_tag) { create(:tag) }
    let(:existing_tag_attr) { existing_tag.as_json(only: %i[id name]) }
    subject { build(:ticket, tags_attributes: [new_tag_attr, existing_tag_attr].map(&:symbolize_keys)) }

    it 'creates new tags' do
      expect { subject.save }.to change { Tag.count }.by(1)
    end

    it 'adds references on existing tags' do
      subject.save

      expect(subject.tags).to include(existing_tag)
    end

    context 'when id not set but tag exists' do
      let!(:new_tag) { Tag.create(new_tag_attr) }

      it 'add references on existing tag' do
        expect { subject.save }.not_to change { Tag.count }
        expect(subject.tags).to include(new_tag, existing_tag)
      end
    end
  end

  describe '#update_by_state' do
    context 'when ticket has published state' do
      before do
        subject.state = :published
        allow_any_instance_of(Api::V1::Tickets::PublishedState).to receive(:update).and_return(true)
      end

      it 'creates Api::V1::Tickets::PublishedState instance' do
        expect(Api::V1::Tickets::PublishedState).to receive(:new).with(subject).and_call_original

        subject.update_by_state(subject.as_json)
      end

      it 'calls update method for Api::V1::Tickets::PublishedState instance' do
        expect_any_instance_of(Api::V1::Tickets::PublishedState).to receive(:update).and_return(true)

        subject.update_by_state(subject.as_json)
      end
    end

    context 'when ticket has draft state' do
      before do
        subject.state = :draft
        allow_any_instance_of(Api::V1::Tickets::DraftState).to receive(:update).and_return(true)
      end

      it 'creates Api::V1::Tickets::DraftState instance' do
        expect(Api::V1::Tickets::DraftState).to receive(:new).with(subject).and_call_original

        subject.update_by_state(subject.as_json)
      end

      it 'calls update method for Api::V1::Tickets::DraftState instance' do
        expect_any_instance_of(Api::V1::Tickets::DraftState).to receive(:update).and_return(true)

        subject.update_by_state(subject.as_json)
      end
    end
  end
end
