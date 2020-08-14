require 'rails_helper'

RSpec.describe Template::Work, type: :model do
  it { is_expected.to belong_to(:app_template) }
end
