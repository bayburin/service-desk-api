require 'rails_helper'

module Api
  module V1
    RSpec.describe Runtime, type: :model do
      let(:starttime) { Time.zone.now }
      let(:endtime) { Time.zone.now + 4.days }
      let(:time) { Time.zone.now + 2.days }
      subject { Runtime.new(starttime: starttime, endtime: endtime, time: time) }

      describe '#alive?' do
        context 'when :endtime is set' do
          it 'returns false' do
            expect(subject.alive?).to be_falsey
          end
        end

        context 'when :endtime is nil' do
          let(:endtime) { nil }

          it 'returns true' do
            expect(subject.alive?).to be_truthy
          end
        end
      end

      describe '#datetime_format_for' do
        context 'when attribute is nil' do
          let(:starttime) { nil }

          it 'returns nil' do
            expect(subject.datetime_format_for(:starttime)).to eq nil
          end
        end

        context 'when attribute is not nil' do
          it 'returns formatted datetime string' do
            expect(subject.datetime_format_for(:starttime)).to eq starttime.strftime('%d.%m.%Y %H:%M')
          end
        end
      end

      describe '#to_s' do
        let(:starttime_s) { starttime.strftime('%d.%m.%Y') }

        context 'when :alive?' do
          let(:endtime) { nil }
          let(:time_s) { time.strftime('%d.%m.%Y') }

          it 'adds :time to result' do
            expect(subject.to_s).to eq "#{starttime_s} - #{time_s}"
          end
        end

        context 'when !alive?' do
          let(:endtime_s) { endtime.strftime('%d.%m.%Y') }

          it 'adds :endtime to result' do
            expect(subject.to_s).to eq "#{starttime_s} - #{endtime_s}"
          end
        end

        context 'when :starttime is nil' do
          let(:starttime) { nil }

          it 'returns "Время не определено"' do
            expect(subject.to_s).to eq 'Время не определено'
          end
        end

        context 'when alive? and :time is nil' do
          let(:time) { nil }
          let(:endtime) { nil }

          it 'returns "Время не определено"' do
            expect(subject.to_s).to eq 'Время не определено'
          end
        end
      end
    end
  end
end
