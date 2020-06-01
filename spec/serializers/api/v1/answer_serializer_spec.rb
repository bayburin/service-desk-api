require 'rails_helper'

module Api
  module V1
    RSpec.describe AnswerSerializer, type: :model do
      let(:answer) { build(:answer) }
      subject { AnswerSerializer.new(answer).to_json }

      %w[id ticket_id reason answer link is_hidden question attachments].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end
    end
  end
end
