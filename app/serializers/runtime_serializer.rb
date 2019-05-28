class RuntimeSerializer < ActiveModel::Serializer
  attributes :starttime, :endtime, :time, :formatted_starttime, :to_s

  delegate :to_s, to: :object

  def formatted_starttime
    object.datetime_format_for(:starttime)
  end
end
