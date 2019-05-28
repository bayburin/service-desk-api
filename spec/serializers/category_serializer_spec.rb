require 'rails_helper'

RSpec.describe TicketSerializer, type: :model do
  let(:category) { create(:category) }
  subject { CategorySerializer.new(category) }

  %w[id name short_description icon_name popularity services faq].each do |attr|
    it "has #{attr} attribute" do
      expect(subject.to_json).to have_json_path(attr)
    end
  end

  describe '#include_associations?' do
    context 'when :without_associations attribute setted to true' do
      let(:category) { create(:category, without_associations: true) }

      it 'returns false' do
        expect(subject).to receive(:include_associations?).at_least(1).and_return(false)

        subject.to_json
      end

      %w[services faq].each do |attr|
        it "does not have :#{attr} attribute" do
          expect(subject.to_json).not_to have_json_path(attr)
        end
      end
    end

    context 'when :without_associations attribute setted to false' do
      let(:category) { create(:category, without_associations: false) }

      it 'returns true' do
        expect(subject).to receive(:include_associations?).at_least(1).and_return(true)

        subject.to_json
      end

      %w[services faq].each do |attr|
        it "has :#{attr} attribute" do
          expect(subject.to_json).to have_json_path(attr)
        end
      end
    end
  end

  describe '#faq' do
    it 'create instance of Api::V1::QuestionsQuery' do
      expect(Api::V1::QuestionsQuery).to receive(:new).with(category.tickets).and_call_original

      subject.to_json
    end

    it 'runs :visible method' do
      expect_any_instance_of(Api::V1::QuestionsQuery).to receive(:most_popular)

      subject.to_json
    end
  end
end
