require 'rails_helper'

RSpec.describe AppTemplate, type: :model do
  it { is_expected.to have_one(:ticket).dependent(:destroy) }
  it { is_expected.to have_many(:works).class_name('Template::Work').dependent(:destroy) }

  it 'includes Associatable module' do
    expect(subject.singleton_class.ancestors).to include(Associatable)
  end

  it 'includes Belongable module' do
    expect(subject.singleton_class.ancestors).to include(Belongable)
  end
end
