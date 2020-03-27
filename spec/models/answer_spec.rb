require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to have_many(:attachments).class_name('AnswerAttachment').dependent(:destroy) }
  it { is_expected.to belong_to(:ticket) }
  it { is_expected.to belong_to(:question_ticket) }
  it { is_expected.to validate_presence_of(:ticket) }
  it { is_expected.to validate_presence_of(:question_ticket) }
  it { is_expected.to validate_presence_of(:answer) }
end
