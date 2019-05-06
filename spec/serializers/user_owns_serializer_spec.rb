require 'rails_helper'

RSpec.describe UserOwnsSerializer, type: :model do
  let(:service) { create(:service, without_associations: true) }
  let(:service_attributes) { Oj.load(ServiceSerializer.new(service).to_json) }
  let(:user_owns) { UserOwns.new(nil, [service]) }
  subject { UserOwnsSerializer.new(user_owns).to_json }

  %w[items services].each do |attr|
    it "has #{attr} attribute" do
      expect(subject).to have_json_path(attr)
    end
  end

  it 'runs ServiceSerializer for :services attribute' do
    expect(Oj.load(subject)['services'][0]).to eq service_attributes
  end
end
