require 'rails_helper'

module Messaging
  RSpec.describe CaseEventWorker, type: :worker do
    let(:msg) { { user_tn: 17_664, case_id: 123, message: 'Test message' } }

    it 'creates notification record' do
      expect { subject.work(msg.to_json) }.to change { Notification.count }.by(1)
    end

    it 'sets :case type to created notification' do
      subject.work(msg.to_json)

      expect(Notification.last.case_event_type?).to be_truthy
    end

    it 'runs #ack! method' do
      expect(subject).to receive(:ack!)

      subject.work(msg.to_json)
    end

    context 'when record was not created' do
      before { allow_any_instance_of(Notification).to receive(:save).and_return(false) }

      it 'runs #reject! method' do
        expect(subject).to receive(:reject!)

        subject.work(msg.to_json)
      end
    end

    context 'when occured not json string' do
      let(:msg) { 'It is not JSON string' }

      it 'runs #reject! method' do
        expect(subject).to receive(:reject!)

        subject.work(msg)
      end
    end
  end
end
