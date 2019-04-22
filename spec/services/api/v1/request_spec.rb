require 'rails_helper'

module Api
  module V1
    RSpec.describe Request, type: :model do
      subject { Request }
      before { allow(subject).to receive(:const_get).and_return('http://test-api') }

      it 'inherits from Connection' do
        expect(subject).to be < Connection
      end

      describe '.get' do
        let(:data) { { message: 'it works' } }

        context 'when response has 200 status' do
          before { stub_request(:get, 'http://test-api/cases.json').to_return(status: 200, body: Oj.dump(data)) }

          it 'returns data' do
            expect(subject.get('cases.json')).to eq data.as_json
          end
        end
      end

      describe '.post' do
        let(:sended_data) { { message: 'it works' } }
        let(:returned_data) { { id: 12_345 } }

        context  'when response has 200 status' do
          before { stub_request(:post, 'http://test-api/cases.json').with(body: Oj.dump(sended_data)).to_return(status: 200, body: Oj.dump(returned_data)) }

          it 'returns data' do
            expect(subject.post('cases.json', sended_data)).to eq returned_data.as_json
          end
        end
      end
    end
  end
end
