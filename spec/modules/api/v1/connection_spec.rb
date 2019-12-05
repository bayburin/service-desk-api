require 'rails_helper'

module Api
  module V1
    class FooClass
      API_ENDPOINT = 'http://test_url'

      include Connection
    end

    RSpec.describe Connection do
      describe 'instance method' do
        subject { FooClass.new }

        describe '#connect' do
          it 'returns instance of Faraday' do
            expect(subject.connect).to be_instance_of(Faraday::Connection)
          end
        end
      end

      describe 'class method' do
        subject { FooClass }

        describe '.connect' do
          it 'returns instance of Faraday' do
            expect(subject.connect).to be_instance_of(Faraday::Connection)
          end
        end
      end
    end
  end
end
