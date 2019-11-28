module ReadCache
  def self.redis
    @redis ||= Redis.new(Rails.application.config_for(:redis))
  end
end
