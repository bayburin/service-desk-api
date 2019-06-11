require 'rails_helper'

RSpec.describe CaseSerializer, type: :model do
  let(:kase) { build(:case) }
  subject { CaseSerializer.new(kase) }

  %w[case_id service_id ticket_id user_tn id_tn user_info host_id item_id desc phone email mobile status_id status runtime service ticket rating].each do |attr|
    it "has #{attr} attribute" do
      expect(subject.to_json).to have_json_path(attr)
    end
  end

  describe '#runtime' do
    it 'creates ActiveModelSerializers::SerializableResource instance' do
      expect(ActiveModelSerializers::SerializableResource).to receive(:new).with(kase.runtime).and_call_original

      subject.to_json
    end

    it 'runs :serializable_hash method for SerializableResource instasnce' do
      expect_any_instance_of(ActiveModelSerializers::SerializableResource).to receive(:serializable_hash)

      subject.to_json
    end

    it 'assigns result to the :runtime attribute' do
      expect(Oj.load(subject.to_json)['runtime']).to eq ActiveModelSerializers::SerializableResource.new(kase.runtime).serializable_hash.as_json
    end
  end
end
