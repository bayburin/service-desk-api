require 'rails_helper'

module Api
  module V1
    RSpec.describe CaseSaveProxy, type: :model do
      let(:item_id) { 999 }
      let(:invent_num) { 'new invent num' }
      let(:item) { double(:item, item_id: item_id, invent_num: invent_num) }
      let!(:kase) { build(:case, host_id: nil, item_id: nil, item: item) }

      subject { CaseSaveProxy.new(kase) }

      %i[save update].each do |method|
        before do
          stub_request(:post, 'https://astraea-ui.iss-reshetnev.ru/api/cases.json').to_return(status: 200, body: '', headers: {})
          stub_request(:put, "https://astraea-ui.iss-reshetnev.ru/api/cases/#{kase.case_id}.json").to_return(status: 200, body: '', headers: {})
        end

        context "when run #{method} method" do
          it 'receives :method_missing method' do
            expect(subject).to receive(:method_missing)

            subject.send(method)
          end

          it "respond_to #{method} method" do
            expect(subject.respond_to?(method)).to be_truthy
          end

          %i[item_id invent_num].each do |attr|
            it "adds #{attr} attribute to the kase" do
              subject.send(method)

              expect(subject.kase.send(attr)).to eq send(attr)
            end

            context 'and when attribute :without_item is true' do
              let!(:kase) { build(:case, host_id: nil, item_id: nil, item: item, without_item: true) }

              it "does not add #{attr} attribute" do
                subject.send(method)

                expect(subject.kase.has_attibute?(send(attr))).to be_falsey
              end
            end
          end
        end
      end
    end
  end
end
