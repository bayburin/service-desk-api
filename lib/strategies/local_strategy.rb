class LocalStrategy
  attr_reader :successor

  def initialize(successor = nil)
    @successor = successor
  end

  def check_access(user_data)
    user = process_checking_access(user_data)
    if user
      user
    elsif successor
      successor.check_access(user_data)
    else
      failed_strategy
    end
  end

  def process_checking_access(_user_data)
    raise 'Not implemented'
  end

  def failed_strategy
    raise 'Auth Strategy could not be invoked'
  end
end
