require 'rails_helper'

module Api
  module V1
    module Svt
      RSpec.describe SvtApi, type: :model do
        describe '#items' do
          let!(:user) { build(:user_iss) }

          it 'runs :get method' do
            expect(Api::V1::Cases::Request).to receive(:get).with("user_isses/#{user.id_tn}/items")

            subject.item(user)
          end
        end
      end
    end
  end
end
