class LocalStrategy
  attr_reader :successor

  def initialize(successor = nil)
    @successor = successor
  end

  def search_user(user_data)
    user = process_searching_user(user_data)
    if user
      user
    elsif successor
      successor.search_user(user_data)
    else
      failed_strategy
    end
  end

  def process_searching_user(_user_data)
    raise 'Not implemented'
  end

  def failed_strategy
    raise 'Auth Strategy could not be invoked'
  end
end
