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
            before { allow(Api::V1::Cases::Request).to receive(:get).with('cases.json', anything).and_return(response.as_json) }

            it 'runs :get method' do
              expect(Api::V1::Cases::Request).to receive(:get).with('cases.json', {})

              subject.query
            end

            it 'creates instances of Case' do
              subject.query['cases'].each do |kase_i|
                expect(kase_i).to be_instance_of Case
              end
            end
          end

          describe '.save' do
            let(:kase) { build(:case) }

            it 'runs :post method' do
              expect(Api::V1::Cases::Request).to receive(:post).with('cases.json', an_instance_of(Case))

              subject.save(build(:case))
            end

            context 'when kase was saved' do
              let(:response) { { case_id: 12_345 } }

              before { allow(Api::V1::Cases::Request).to receive(:post).with('cases.json', kase).and_return(response.as_json) }

              it 'returns kase' do
                expect(subject.save(kase)).to be_instance_of(Case)
              end

              it 'changes :case_id attribute of Case' do
                expect { subject.save(kase) }.to change { kase.case_id }.to(response.as_json['case_id'])
              end
            end

            context 'when kase was not saved' do
              before { allow(Api::V1::Cases::Request).to receive(:post).with('cases.json', kase).and_return(nil) }

              it 'returns nil' do
                expect(subject.save(kase)).to be_nil
              end

              it 'does not change :case_id attribute of Case' do
                expect { subject.save(kase) }.not_to change { kase.case_id }
              end
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
            before { allow(Api::V1::Cases::Request).to receive(:get).with('cases.json', anything).and_return(response.as_json) }

            it 'runs :get method' do
              expect(Api::V1::Cases::Request).to receive(:get).with('cases.json', {})

              subject.query
            end

            it 'runs :get method with params from @case_params variable' do
              expect(Api::V1::Cases::Request).to receive(:get).with('cases.json', foo: :bar, user_tn: 12_345)

              subject.where(foo: :bar).query(user_tn: 12_345)
            end

            it 'creates instances of Case' do
              subject.query['cases'].each do |kase_i|
                expect(kase_i).to be_instance_of Case
              end
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
