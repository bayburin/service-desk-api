require 'rails_helper'

RSpec.describe EventLogReader, type: :model do
  it { is_expected.to belong_to(:event_log) }
end