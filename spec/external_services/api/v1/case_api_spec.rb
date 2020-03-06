require 'rails_helper'

module Api
  module V1
    RSpec.describe CaseApi, type: :model do
      let(:astraea_url) { "#{ENV['ASTRAEA_URL']}/cases.json" }

      describe 'class methods' do
        subject { CaseApi }

        describe '.query' do
          let(:response) { { cases: [attributes_for(:case)] } }
          let(:params) { { foo: :bar } }

          before { stub_request(:get, /#{astraea_url}.*/).to_return(status: 200, body: response.to_json, headers: {}) }

          it 'sends :get request with params' do
            subject.query(params)

            expect(WebMock).to have_requested(:get, astraea_url).with(query: params)
          end

          it 'creates instances of Case' do
            subject.query(params).body['cases'].each { |kase| expect(kase).to be_instance_of(Case) }
          end

          it 'returns instance of Faraday::Response class' do
            expect(subject.query(params)).to be_instance_of(Faraday::Response)
          end
        end

        describe '.save' do
          let(:kase) { build(:case) }

          before { stub_request(:post, astraea_url).to_return(status: 200, body: '', headers: {}) }

          it 'sends :post request with kase params' do
            subject.save(kase)

            expect(WebMock).to have_requested(:post, astraea_url).with(body: kase.to_json)
          end

          it 'returns instance of Faraday::Response class' do
            expect(subject.save(kase)).to be_instance_of(Faraday::Response)
          end
        end

        describe '.update' do
          let(:case_id) { '12345' }
          let(:kase) { build(:case, case_id: case_id) }
          let(:astraea_url) { "#{ENV['ASTRAEA_URL']}/cases/#{case_id}.json" }

          before { stub_request(:put, astraea_url).to_return(status: 200, body: '', headers: {}) }

          it 'sends :put request with kase params' do
            subject.update(case_id, kase)

            expect(WebMock).to have_requested(:put, astraea_url).with(body: kase.to_json)
          end

          it 'returns instance of Faraday::Response class' do
            expect(subject.update(case_id, kase)).to be_instance_of(Faraday::Response)
          end
        end

        describe '.where' do
          it 'creates and returns new instance of class' do
            expect(subject.where(foo: :bar)).to be_instance_of(CaseApi)
          end

          it 'merge passed parameters with @case_params' do
            expect(subject.where(foo: :bar).instance_variable_get(:@case_params)).to eq(foo: :bar)
          end
        end
      end

      describe 'instance methods' do
        describe '#query' do
          let(:response) { { cases: [attributes_for(:case)] } }
          let(:where) { { user_tn: 12_345 } }
          let(:params) { { foo: :bar } }

          before { stub_request(:get, /#{astraea_url}.*/).to_return(status: 200, body: response.to_json, headers: {}) }

          it 'sends :get request with params' do
            subject.where(where).query(params)

            expect(WebMock).to have_requested(:get, astraea_url).with(query: where.merge(params))
          end

          it 'creates instances of Case' do
            subject.where(where).query(params).body['cases'].each { |kase| expect(kase).to be_instance_of(Case) }
          end

          it 'returns instance of Faraday::Response class' do
            expect(subject.where(where).query(params)).to be_instance_of(Faraday::Response)
          end
        end

        describe '#destroy' do
          let(:params) { { case_id: 12_345 } }

          before { stub_request(:delete, /#{astraea_url}.*/).to_return(status: 200, body: '', headers: {}) }

          it 'sends :delete request' do
            subject.destroy(params)

            expect(WebMock).to have_requested(:delete, astraea_url).with(query: params)
          end

          it 'returns instance of Faradat::Response class' do
            expect(subject.destroy(params)).to be_instance_of(Faraday::Response)
          end
        end

        describe '#where' do
          let!(:object_id) { subject.object_id }

          it 'returns the same instance of class' do
            expect(subject.where(foo: :bar).object_id).to eq object_id
          end

          it 'merge passed parameters with @case_params' do
            expect(subject.where(foo: :bar).instance_variable_get(:@case_params)).to eq(foo: :bar)
          end
        end
      end
    end
  end
end
