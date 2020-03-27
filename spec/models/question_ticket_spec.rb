require 'rails_helper'

RSpec.describe QuestionTicket, type: :model do
  it { is_expected.to have_many(:answers).dependent(:destroy) }
end
