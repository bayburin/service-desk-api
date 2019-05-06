module Api
  module V1
    class Timestamp < Virtus::Attribute
      def coerce(time)
        time ? DateTime.strptime(time.to_s, '%s').in_time_zone : nil
      end
    end
  end
end
