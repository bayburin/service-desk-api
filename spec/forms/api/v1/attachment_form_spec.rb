require 'rails_helper'

module Api
  module V1
    RSpec.describe AttachmentForm, type: :model do
      subject { described_class.new(AnswerAttachment.new) }

      it { is_expected.to validate_presence_of(:document) }
    end
  end
end
