require 'rails_helper'

module Api
  module V1
    module Svt
      RSpec.describe SvtApi, type: :model do
        describe '#items' do
          let!(:user) { build(:user_iss) }
          let(:item_data) { [] }
          subject { Api::V1::Svt::SvtApi }

          it 'runs :get method' do
            expect(Api::V1::Svt::Request).to receive(:get).with("user_isses/#{user.id_tn}/items", {})

            subject.items(user)
          end
        end
      end
    end
  end
end
