require 'rails_helper'

RSpec.describe UpdateIndicesWorker, type: :worker do
  it 'runs ts:index command' do
    expect(subject).to receive(:system).with('rails ts:index')

    subject.perform
  end
end
