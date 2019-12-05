module Api
  module V1
    class RuntimeSerializer < ActiveModel::Serializer
      attributes :starttime, :endtime, :time, :formatted_starttime, :formatted_endtime, :formatted_time, :to_s

      delegate :to_s, to: :object

      def formatted_starttime
        object.datetime_format_for(:starttime)
      end

      def formatted_endtime
        object.datetime_format_for(:endtime)
      end

      def formatted_time
        object.datetime_format_for(:time)
      end
    end
  end
end
