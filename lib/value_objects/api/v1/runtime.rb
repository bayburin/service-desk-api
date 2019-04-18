module Api
  module V1
    # Класс, обрабатывающий аттрибуты времени в заявке.
    class Runtime
      include ActiveModel::Serialization

      DATE_FORMAT = '%d.%m.%Y'.freeze
      TIME_FORMAT = '%H:%M'.freeze

      attr_reader :starttime, :endtime, :time

      # starttime - DATETIME
      # endtime - DATETIME
      # time - TIMESTAMP
      def initialize(starttime, endtime, time)
        @starttime = Time.zone.parse(starttime.to_s)
        @endtime = Time.zone.parse(endtime.to_s)
        @time = time ? DateTime.strptime(time.to_s, '%s').in_time_zone : nil
      end

      def alive?
        !endtime
      end

      def datetime_format_for(attribute)
        return unless send(attribute)

        send(attribute).strftime("#{DATE_FORMAT} #{TIME_FORMAT}")
      end

      def to_s
        return 'Время не определено' if time_not_defined?

        lasttime = alive? ? time : endtime

        "#{starttime.strftime(DATE_FORMAT)}-#{lasttime.strftime(DATE_FORMAT)}"
      end

      private

      def time_not_defined?
        !starttime || (alive? && !time)
      end
    end
  end
end
