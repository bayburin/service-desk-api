require 'rails_helper'

module Api
  module V1
    RSpec.describe EmployeeApi, type: :model do
      subject { EmployeeApi }

      it 'define API_ENDPOINT constant' do
        expect(subject.const_defined?(:API_ENDPOINT)).to be_truthy
      end

      it 'included Api::V1::Connection module' do
        expect(subject.singleton_class.ancestors).to include(Connection::ClassMethods)
      end

      describe '::login' do
        let(:username) { 'username' }
        let(:password) { 'password' }
        before { stub_request(:post, 'https://hr.iss-reshetnev.ru/ref-info/api/login').to_return(status: 200, body: '', headers: {}) }

        it 'sends :post request with required headers' do
          ENV['EMPLOYEE_DATABASE_USERNAME'] = username
          ENV['EMPLOYEE_DATABASE_PASSWORD'] = password
          subject.login

          expect(WebMock).to have_requested(:post, 'https://hr.iss-reshetnev.ru/ref-info/api/login')
                               .with(headers: { 'X-Auth-Username': username, 'X-Auth-Password': password })
        end

        it 'returns instance of Faraday::Response class' do
          expect(subject.login).to be_instance_of(Faraday::Response)
        end
      end

      describe '::load_users' do
        let(:token) { 'custom_token' }
        let(:server_url) { 'https://hr.iss-reshetnev.ru/ref-info/api/emp' }
        before { allow_any_instance_of(Employees::Authorize).to receive(:token).and_return(token) }
        before { stub_request(:get, /#{server_url}.*/).to_return(status: 200, body: '', headers: {}) }

        it 'sends :post request with required params and headers' do
          subject.load_users([123])

          expect(WebMock).to have_requested(:get, 'https://hr.iss-reshetnev.ru/ref-info/api/emp?search=personnelNo=in=(123)')
                               .with(headers: { 'X-Auth-Token': token })
        end

        it 'returns instance of Faraday::Response class' do
          expect(subject.load_users([123])).to be_instance_of(Faraday::Response)
        end
      end
    end
  end
end
