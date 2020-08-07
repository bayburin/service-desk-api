require 'rails_helper'

module Api
  module V1
    module Questions
      RSpec.describe AnswerForm, type: :model do
        subject { described_class.new(Answer.new) }

        it { is_expected.to validate_presence_of(:answer) }

        describe '#populate_attachments' do
          let(:original_files) { create_list(:answer_attachment, 2) }
          before { subject.populate_attachments(original_files) }

          it 'add files to attachments collection' do
            expect(subject.attachments.count).to eq original_files.count
          end

          it 'copy files' do
            subject.attachments.each_with_index do |file, index|
              expect(IO.read(file.document.file.file)).to eq IO.read(original_files[index].document.file.file)
            end
          end
        end
      end
    end
  end
end
