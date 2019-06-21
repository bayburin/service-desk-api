require 'rails_helper'

RSpec.describe RuntimeSerializer, type: :model do
  let(:runtime) { Api::V1::Runtime.new(starttime: Time.zone.now - 2.days, endtime: Time.zone.now, time: Time.zone.now.to_i) }
  subject { RuntimeSerializer.new(runtime) }

  %w[starttime endtime time formatted_starttime formatted_endtime formatted_time to_s].each do |attr|
    it "has #{attr} attribute" do
      expect(subject.to_json).to have_json_path(attr)
    end
  end

  %i[starttime endtime time].each do |attr|
    describe "#formatted_#{attr}" do
      it "runs :datetime_format_for method for #{attr} attribute" do
        expect(runtime).to receive(:datetime_format_for).with(attr)

        subject.send("formatted_#{attr}".to_sym)
      end
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
