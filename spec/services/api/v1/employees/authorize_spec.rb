require 'rails_helper'

module Api
  module V1
    module Employees
      RSpec.describe Authorize do
        let!(:redis) { ReadCache.redis }
        let(:token) { 'test_token' }

        describe '#token' do
          before { redis.set('employee_token', token) }

          it 'should return token from redis database' do
            expect(subject.token).to eq token
          end
        end

        describe '#token=' do
          let(:new_token) { 'new_test_token' }

          it 'should set new token' do
            subject.token = new_token

            expect(subject.token).to eq new_token
          end
        end

        describe 'authorize' do
          let(:new_token) { 'new_test_token' }
          let(:response) { double('response', status: 200, body: { token: new_token }.as_json, success?: true) }
          before { allow(EmployeeApi).to receive(:login).and_return(response) }

          it 'should receive new token and save it' do
            subject.authorize

            expect(subject.token).to eq new_token
          end
        end

        describe 'clear' do
          it 'deletes token from redis database' do
            subject.token = token
            subject.clear

            expect(subject.token).to be_nil
          end
        end
      end
    end
  end
end
