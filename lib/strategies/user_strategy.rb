class UserStrategy < LocalStrategy
  def process_searching_user(user_data)
    return unless user_data['tn'] && ::User.exists?(tn: user_data['tn'])

    Rails.logger.debug { "It's a existing User".cyan }
    ::User.find_by(tn: user_data['tn'])
  end
end
