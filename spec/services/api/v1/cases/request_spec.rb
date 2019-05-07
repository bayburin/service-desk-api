require 'rails_helper'

module Api
  module V1
    module Cases
      RSpec.describe Request, type: :model do
        subject { Request }

        it 'inherits from Api::V1::Request' do
          expect(subject).to be < Api::V1::ApiConnection
        end

        it 'sets API_ENDPOINT constant' do
          expect(subject::API_ENDPOINT).to eq 'https://astraea-ui.iss-reshetnev.ru/api/'
        end
      end
    end
  end
end
