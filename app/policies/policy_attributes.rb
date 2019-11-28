class PolicyAttributes
  attr_reader :serializer, :sql_include, :serialize

  def initialize(attributes = {})
    @serializer = attributes[:serializer]
    @sql_include = attributes[:sql_include] || []
    @serialize = attributes[:serialize] || []
  end
end
