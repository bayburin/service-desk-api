require 'rails_helper'

module Api
  module V1
    RSpec.describe ResponsibleUserDetails, type: :model do
      let(:params) do
        {
          id: 123,
          lastName: 'Федоров',
          firstName: 'Максим',
          middleName: 'Евгеньевич',
          fullName: 'Федоров Максим Евгеньевич',
          personnelNo: 876,
          deptForDocs: 999,
          phoneText: '32-32'
        }.as_json
      end
      subject { ResponsibleUserDetails.new(params) }

      it 'fills attributes' do
        expect(subject.id_tn).to eq params['id']
        expect(subject.last_name).to eq params['lastName']
        expect(subject.first_name).to eq params['firstName']
        expect(subject.middle_name).to eq params['middleName']
        expect(subject.full_name).to eq params['fullName']
        expect(subject.tn).to eq params['personnelNo']
        expect(subject.dept).to eq params['deptForDocs']
        expect(subject.phone).to eq params['phoneText']
      end
    end
  end
end
