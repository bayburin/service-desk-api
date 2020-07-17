require 'rails_helper'

module Api
  module V1
    RSpec.describe ResponsibleUserForm, type: :model do
      subject { described_class.new(ResponsibleUser.new) }

      it { is_expected.to validate_presence_of(:tn) }
    end
  end
end
