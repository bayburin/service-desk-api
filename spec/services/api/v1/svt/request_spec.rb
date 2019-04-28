require 'rails_helper'

module Api
  module V1
    module Svt
      RSpec.describe Request, type: :model do
        subject { Request }

        it 'inherits from Api::V1::Request' do
          expect(subject).to be < Api::V1::Connection
        end

        it 'sets API_ENDPOINT constant' do
          expect(subject::API_ENDPOINT).to eq ENV['SVT_NAME']
        end
      end
    end
  end
end
