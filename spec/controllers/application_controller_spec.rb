require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#GET welcome' do
    let(:tracker) { Ahoy::Tracker.new(controller: controller) }

    before { allow(Ahoy::Tracker).to receive(:new).and_return(tracker) }

    it 'renders nothing' do
      get :welcome

      expect(response.body).to be_blank
    end

    it 'tracks event' do
      expect(tracker).to receive(:track).with('Ran action', action: 'welcome', controller: 'application')

      get :welcome, format: :json
    end
  end
end
