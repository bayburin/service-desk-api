require 'rails_helper'

module Api
  module V1
    module Employees
      RSpec.describe UserRequestChanger do
        subject { UserRequestChanger }

        describe '::request' do
          context 'when type is equal "exact" value' do
            let(:type) { :exact }
            let(:params) { { tns: [1, 1, 2] } }

            it 'calls EmployeeApi::load_users method' do
              expect(EmployeeApi).to receive(:load_users).with(params[:tns].uniq)

              subject.request(type, params)
            end
          end
          
          context 'when type is equal "like" value' do
            let(:type) { :like }
            let(:params) { { field: 'field_name', term: 'search_string' } }

            it 'calls EmployeeApi::load_users_like method' do
              expect(EmployeeApi).to receive(:load_users_like).with(params[:field], params[:term])

              subject.request(type, params)
            end
          end
        end
      end
    end
  end
end
