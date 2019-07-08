require 'rails_helper'

RSpec.describe EventLog, type: :model do
  it { is_expected.to have_many(:readers).class_name(EventLogReader).with_foreign_key(:event_log_id).dependent(:destroy) }
end
