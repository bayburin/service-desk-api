require 'rails_helper'

module Api
  module V1
    RSpec.describe AppSaveDecorator, type: :model do
      let(:item_id) { 999 }
      let(:invent_num) { 'new invent num' }
      let(:common_ticket) { create(:ticket, :common_case) }
      let(:connect_ticket) { create(:ticket, :app) }
      let!(:service) { create(:service, tickets: [common_ticket, connect_ticket]) }
      let!(:app) { build(:app, host_id: nil, item_id: nil, service: service) }
      subject { described_class.new(app) }

      before do
        # stub_request(:post, 'https://astraea-ui.iss-reshetnev.ru/api/cases.json')
        #   .to_return(status: 200, body: '', headers: {})
      end

      context 'when ticket_id is not defined' do
        before { app.ticket_id = nil }

        it 'adds :ticket_id attribute from :FreeApplication type' do
          subject.decorate

          expect(subject.app.ticket_id).to eq common_ticket.id
        end

        it 'adds :sla attribute from :FreeApplication type' do
          subject.decorate

          expect(subject.app.sla).to eq common_ticket.sla
        end

        it 'adds responsible users from :FreeApplication type' do
          subject.decorate

          expect(subject.app.accs).to match_array(common_ticket.responsible_users.pluck(:tn))
        end
      end

      context 'when ticket_id is defined' do
        before { app.ticket_id = connect_ticket.id }

        it 'adds responsible users from current ticket' do
          subject.decorate

          expect(subject.app.accs).to match_array(connect_ticket.responsible_users.pluck(:tn))
        end
      end

      context 'when :common_case is not defined' do
        before { allow(subject).to receive(:find_ticket).and_return(nil) }

        it 'returns true' do
          expect(subject.decorate).to be_truthy
        end
      end

      context 'when responsible_users is empty' do
        before { allow_any_instance_of(Ticket).to receive(:responsibles).and_return([]) }

        it 'sets empty array to :accs attribute' do
          subject.decorate

          expect(subject.app.accs).to be_empty
        end
      end

      context 'when files exists' do
        let(:result) { 'base64_encoded_string' }
        let(:file) { { filename: 'test.png', file: "data:application/pdf,#{result}" }.as_json }
        before { app[:files] = [file] }

        it 'should remove metadata from string encoded by base64' do
          subject.decorate

          expect(subject.app[:files].first['file']).to eq result
        end
      end
    end
  end
end
