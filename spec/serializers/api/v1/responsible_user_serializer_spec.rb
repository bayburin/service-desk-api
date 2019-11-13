require 'rails_helper'

module Api
  module V1
    RSpec.describe ResponsibleUserSerializer, type: :model do
      let(:user) { create(:service_responsible_user) }
      let(:service) { create(:service) }
      let(:responsible) { service.responsible_users.first }
      subject { ResponsibleUserSerializer.new(responsible).to_json }
      before { user.services << service }

      %w[id responseable_type responseable_id tn details].each do |attr|
        it "has #{attr} attribute" do
          expect(subject).to have_json_path(attr)
        end
      end

      describe '#details' do
        before { responsible.details = {} }

        it 'creates ActiveModelSerializers::SerializableResource instance' do
          expect(ActiveModelSerializers::SerializableResource).to receive(:new).with(responsible.details).and_call_original

          subject.to_json
        end
      end
    end
  end
end
