require 'rails_helper'

module Api
  module V1
    module AuthCenter
      RSpec.describe AccessToken do
        let(:token) { 'my_token' }
        let(:user_info) { { fio: 'test', tn: 123 }.as_json }
        subject { AccessToken }

        describe '.get, .set' do
          before { subject.set(token, user_info) }

          it 'return user data' do
            expect(subject.get(token)).to eq user_info
          end
        end

        describe '.del' do
          before do
            subject.set(token, user_info)
            subject.del(token)
          end

          it 'remove data from database' do
            expect(subject.get(token)).to be_nil
          end
        end
      end
    end
  end
end
