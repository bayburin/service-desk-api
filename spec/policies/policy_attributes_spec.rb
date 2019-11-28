require 'rails_helper'

RSpec.describe PolicyAttributes do
  subject(:policy) do
    PolicyAttributes.new(
      serializer: 'test serializer',
      sql_include: 'test sql_include',
      serialize: 'test serialize'
    )
  end

  it 'should create instance of PolicyAttributes with specified attributes' do
    expect(policy.serializer).to eq 'test serializer'
    expect(policy.sql_include).to eq 'test sql_include'
    expect(policy.serialize).to eq 'test serialize'
  end
end
