require 'rails_helper'
RSpec.describe UpdateIndicesWorker, type: :worker do
  it 'runs ts:merge command' do
    expect(subject).to receive(:system).with('rails ts:merge')

    subject.perform
  end
end
