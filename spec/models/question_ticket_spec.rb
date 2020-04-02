require 'rails_helper'

RSpec.describe QuestionTicket, type: :model do
  subject { build(:question_ticket) }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_one(:ticket).dependent(:destroy) }
  it { is_expected.to have_one(:correction).class_name('QuestionTicket').with_foreign_key(:original_id).dependent(:nullify) }
  it { is_expected.to belong_to(:original).class_name('QuestionTicket').optional }
  it { is_expected.to validate_presence_of(:answers) }

  context 'when ticket has :draft state' do
    before { subject.ticket.state = :draft }

    it { is_expected.not_to validate_presence_of(:answers) }
  end
end
