require 'rails_helper'

RSpec.describe ResponsibleUser, type: :model do
  it { is_expected.to belong_to(:responseable) }

  it 'includes Api::V1::UserDetailable module' do
    expect(subject.singleton_class.ancestors).to include(Api::V1::UserDetailable)
  end
end
