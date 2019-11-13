require 'rails_helper'

module Api
  module V1
    module Employees
      RSpec.describe Employee do
        it 'creates instance of Authorize class' do
          expect(subject.instance_variable_get(:@authorize)).to be_instance_of(Authorize)
        end

        it 'sets zero to the @counter variable' do
          expect(subject.instance_variable_get(:@counter)).to be_zero
        end

        describe '#load_users' do
          let(:tns) { [1, 2, 3] }
          let(:data) { { data: [] }.as_json }
          let(:response) { double('response', status: 200, body: data, success?: true) }
          let(:token) { 'custom_toket' }
          before do
            allow_any_instance_of(Authorize).to receive(:token).and_return(token)
            allow(EmployeeApi).to receive(:load_users).and_return(response)
          end

          context 'when @counter is equal its max value' do
            before { subject.instance_variable_set(:@counter, 2) }

            it 'returns nil' do
              expect(subject.load_users(tns)).to be_nil
            end

            it 'sets zero to @counter variable' do
              subject.load_users(tns)

              expect(subject.instance_variable_get(:@counter)).to be_zero
            end
          end

          context 'when EmployeeApi.load_users is not success' do
            let(:response) { double('response', status: 401, body: data, success?: false) }

            it 'calls #load_users max times' do
              expect(subject).to receive(:load_users).exactly(Employee::STOP_COUNTER - 1).times

              subject.load_users(tns)
            end

            it 'calls authorize#clear method' do
              expect(subject.instance_variable_get(:@authorize)).to receive(:clear).exactly(Employee::STOP_COUNTER).times

              subject.load_users(tns)
            end
          end

          it 'returns occured data' do
            expect(subject.load_users(tns)).to eq data
          end
        end
      end
    end
  end
end
