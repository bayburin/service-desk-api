require 'rails_helper'

module Api
  module V1
    RSpec.describe Request, type: :model do
      subject { Request }
      before { allow(subject).to receive(:const_get).and_return('http://test-api') }

      it 'inherits from ApiConnection' do
        expect(subject).to be < ApiConnection
      end

      describe '.get' do
        let(:data) { { message: 'it works' } }

        context 'when response has 200 status' do
          before { stub_request(:get, 'http://test-api/cases.json').to_return(status: 200, body: data.to_json) }

          it 'returns response instance' do
            expect(subject.get('cases.json')).to be_instance_of(Faraday::Response)
          end

          it 'returns data into response instance' do
            expect(subject.get('cases.json').body).to eq data.as_json
          end
        end
      end

      describe '.post' do
        let(:sended_data) { { message: 'it works' } }
        let(:returned_data) { { id: 12_345 } }

        before { stub_request(:post, 'http://test-api/cases.json').with(body: sended_data.to_json).to_return(status: 200, body: returned_data.to_json) }

        it 'returns response instance' do
          expect(subject.post('cases.json', sended_data)).to be_instance_of(Faraday::Response)
        end

        it 'returns data' do
          expect(subject.post('cases.json', sended_data).body).to eq returned_data.as_json
        end
      end

      describe '.delete' do
        let(:sended_data) { { case_id: 12_345 } }
        let(:returned_data) { { message: 'it works' } }

        before { stub_request(:delete, "http://test-api/cases.json?case_id=#{sended_data[:case_id]}").to_return(status: 200, body: returned_data.to_json) }

        it 'returns response instance' do
          expect(subject.delete('cases.json', sended_data)).to be_instance_of(Faraday::Response)
        end

        it 'returns data' do
          expect(subject.delete('cases.json', sended_data).body).to eq returned_data.as_json
        end
      end
    end
  end
end
