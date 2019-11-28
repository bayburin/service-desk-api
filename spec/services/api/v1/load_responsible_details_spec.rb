require 'rails_helper'

module Api
  module V1
    RSpec.describe LoadResponsibleDetails do
      let(:tickets) { create_list(:ticket, 2) }
      let(:ticket) { tickets.first }
      let!(:responsible_user) { create(:responsible_user, responseable: ticket) }
      let(:numbers) { ResponsibleUser.pluck(:tn) }
      let(:fio) { 'Тестовое ФИО' }
      let(:data) { { data: [{ personnelNo: ticket.responsible_users.first.tn, fullName: fio }] }.as_json }
      subject { LoadResponsibleDetails.new(tickets) }
      before { allow_any_instance_of(Employees::Employee).to receive(:load_users).and_return(data) }

      describe '#load_details' do
        it 'calls :load_users method for Employees::Employee class' do
          expect_any_instance_of(Employees::Employee).to receive(:load_users).with(numbers)

          subject.load_details
        end

        it 'saves occured data in @details variable' do
          subject.load_details

          expect(subject.instance_variable_get(:@details)).to eq data
        end
      end

      describe '#associate_details!' do
        before { subject.load_details }

        it 'associates occured data with tickets' do
          subject.associate_details!

          expect(ticket.responsible_users.first.details.full_name).to eq fio
        end
      end
    end
  end
end
