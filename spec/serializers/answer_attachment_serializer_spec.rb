require 'rails_helper'

RSpec.describe AnswerAttachmentSerializer, type: :model do
  let(:ticket) { create(:ticket) }
  let!(:answer_attachment) { build(:answer_attachment, answer: ticket.answers.first) }
  subject { AnswerAttachmentSerializer.new(answer_attachment) }

  %w[id answer_id filename].each do |attr|
    it "has #{attr} attribute" do
      expect(subject.to_json).to have_json_path(attr)
    end
  end

  it 'has original filename in :filename attribute' do
    expect(subject.filename).to eq answer_attachment.document.filename
  end
end
