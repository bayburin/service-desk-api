require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_one(:ticket).dependent(:destroy) }
  it { is_expected.to have_one(:correction).class_name('Question').with_foreign_key(:original_id).dependent(:nullify) }
  it { is_expected.to have_many(:responsible_users).through(:ticket) }
  it { is_expected.to belong_to(:original).class_name('Question').optional }

  it 'includes Associatable module' do
    expect(subject.singleton_class.ancestors).to include(Associatable)
  end

  it 'includes Belongable module' do
    expect(subject.singleton_class.ancestors).to include(Belongable)
  end
end
