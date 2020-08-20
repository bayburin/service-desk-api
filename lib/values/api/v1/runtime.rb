module Api
  module V1
    # Класс, обрабатывающий аттрибуты времени в заявке.
    class Runtime
      include ActiveModel::Serialization
      include Virtus.value_object

      DATE_FORMAT = '%d.%m.%Y'.freeze
      TIME_FORMAT = '%H:%M'.freeze

      values do
        attribute :starttime, DateTime
        attribute :endtime, DateTime
        attribute :time, DateTime
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

        "#{starttime.strftime(DATE_FORMAT)} - #{lasttime.strftime(DATE_FORMAT)}"
      end

      private

      def time_not_defined?
        !starttime || (alive? && !time)
      end
    end
  end
end
