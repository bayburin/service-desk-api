require 'rails_helper'

RSpec.describe RuntimeSerializer, type: :model do
  let(:runtime) { Api::V1::Runtime.new(starttime: Time.zone.now - 2.days, endtime: Time.zone.now, time: Time.zone.now.to_i) }
  subject { RuntimeSerializer.new(runtime) }

  %w[starttime endtime time formatted_starttime to_s].each do |attr|
    it "has #{attr} attribute" do
      expect(subject.to_json).to have_json_path(attr)
    end
  end

  describe '#formatted_starttime' do
    it 'runs :datetime_format_for method for :starttime attribute' do
      expect(runtime).to receive(:datetime_format_for).with(:starttime)

      subject.to_json
    end
  end

  describe '#to_s' do
    it 'runs method :to_s' do
      expect(runtime).to receive(:to_s)

      subject.to_json
    end

    it 'assigns result to the :to_s attribute' do
      expect(Oj.load(subject.to_json)['to_s']).to eq runtime.to_s
    end
  end
end
