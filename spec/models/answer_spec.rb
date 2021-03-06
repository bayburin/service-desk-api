require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to have_many(:attachments).class_name('AnswerAttachment').dependent(:destroy) }
  it { is_expected.to belong_to(:question) }
end
