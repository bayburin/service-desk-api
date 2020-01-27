require 'rails_helper'

module Api
  module V1
    RSpec.describe UserDetailable do
      let!(:user) { create(:user) }
      subject { user.extend(UserDetailable) }

      describe '#details=' do
        it 'creates instance of UserDetails' do
          subject.details = {}

          expect(subject.details).to be_instance_of(UserDetails)
        end
      end

      describe '#load_details' do
        let(:email) { 'test@iss-reshetnev.ru' }
        let(:result) { { data: [{ emailText: email }] }.as_json }

        it 'calls #load_users method for Employees::Employee instance' do
          expect_any_instance_of(Employees::Employee).to receive(:load_users).and_return(result)

          subject.load_details
        end

        it 'saves data into details attribute' do
          allow_any_instance_of(Employees::Employee).to receive(:load_users).and_return(result)
          subject.load_details

          expect(subject.details.email).to eq email
        end
      end
    end
  end
end
