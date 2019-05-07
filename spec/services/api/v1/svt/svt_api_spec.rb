require 'rails_helper'

module Api
  module V1
    module Svt
      RSpec.describe SvtApi, type: :model do
        describe '#items' do
          let!(:user) { build(:user_iss) }
          let(:item_data) { [] }
          subject { Api::V1::Svt::SvtApi }

          before { stub_request(:get, 'https://staging-svt.iss-reshetnev.ru/user_isses/-110/items').to_return(status: 200, body: '', headers: {}) }

          it 'runs :get method' do
            expect(Api::V1::Svt::Request).to receive(:get).with("user_isses/#{user.id_tn}/items", {})

            subject.items(user)
          end

          it 'returns instance of Faradat::Response class' do
            expect(subject.items(user)).to be_instance_of(Faraday::Response)
          end
        end
      end
    end
  end
end
