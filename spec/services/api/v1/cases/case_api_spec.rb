require 'rails_helper'

module Api
  module V1
    module Cases
      RSpec.describe CaseApi, type: :model do
        describe 'class methods' do
          subject { Api::V1::Cases::CaseApi }

          describe '.query' do
            let(:kase) { attributes_for(:case) }
            let(:response) { { cases: [kase] } }

            before { stub_request(:get, 'https://astraea-ui.iss-reshetnev.ru/api/cases.json').to_return(status: 200, body: response.to_json, headers: {}) }

            it 'runs :get method' do
              expect(Api::V1::Cases::Request).to receive(:get).with('cases.json', {}).and_call_original

              subject.query
            end

            it 'creates instances of Case' do
              subject.query.body['cases'].each do |kase_i|
                expect(kase_i).to be_instance_of Case
              end
            end
          end

          describe '.save' do
            let(:kase) { build(:case) }

            before { stub_request(:post, 'https://astraea-ui.iss-reshetnev.ru/api/cases.json').to_return(status: 200, body: {}.to_json, headers: {}) }

            it 'runs :post method' do
              expect(Api::V1::Cases::Request).to receive(:post).with('cases.json', an_instance_of(Case))

              subject.save(kase)
            end

            it 'returns instance of Faradat::Response class' do
              expect(subject.save(kase)).to be_instance_of(Faraday::Response)
            end
          end

          describe '.where' do
            it 'creates and returns new instance of class' do
              expect(subject.where(foo: :bar)).to be_instance_of(Api::V1::Cases::CaseApi)
            end

            it 'merge passed parameters with @case_params' do
              expect(subject.where(foo: :bar).instance_variable_get(:@case_params)).to eq(foo: :bar)
            end
          end
        end

        describe 'instance methods' do
          subject { Api::V1::Cases::CaseApi.new }

          describe '#query' do
            let(:kase) { attributes_for(:case) }
            let(:response) { { cases: [kase] } }

            before { stub_request(:get, %r{https://astraea-ui.iss-reshetnev.ru/api/cases.json.*}).to_return(status: 200, body: response.to_json, headers: {}) }

            it 'runs :get method' do
              expect(Api::V1::Cases::Request).to receive(:get).with('cases.json', {}).and_call_original

              subject.query
            end

            it 'runs :get method with params from @case_params variable' do
              expect(Api::V1::Cases::Request).to receive(:get).with('cases.json', foo: :bar, user_tn: 12_345).and_call_original

              subject.where(foo: :bar).query(user_tn: 12_345)
            end

            it 'creates instances of Case' do
              subject.query.body['cases'].each do |kase_i|
                expect(kase_i).to be_instance_of Case
              end
            end
          end

          describe '#destroy' do
            let(:params) { { case_id: 12_345 } }

            before { stub_request(:delete, %r{https://astraea-ui.iss-reshetnev.ru/api/cases.json.*}).to_return(status: 200, body: {}.to_json, headers: {}) }

            it 'runs :destroy method' do
              expect(Api::V1::Cases::Request).to receive(:delete).with('cases.json', params)

              subject.destroy(params)
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
end
