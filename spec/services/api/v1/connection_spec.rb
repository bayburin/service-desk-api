require 'rails_helper'

module Api
  module V1
    RSpec.describe Connection, type: :model do
      subject { Connection }

      describe '.conn' do
        it 'returns instance of Faraday' do
          expect(subject.conn).to be_instance_of(Faraday::Connection)
        end
      end
    end
  end
end
