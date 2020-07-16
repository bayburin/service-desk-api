require 'rails_helper'

module Api
  module V1
    RSpec.describe TagForm, type: :model do
      subject { described_class.new(Tag.new) }

      it { is_expected.to validate_presence_of(:name) }
    end
  end
end
