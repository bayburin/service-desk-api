class UserStrategy < LocalStrategy
  def process_checking_access(user_data)
    return unless ::User.exists?(tn: user_data['tn'])

    Rails.logger.debug { "It's a existing User".cyan }
    ::User.find_by(tn: user_data['tn'])
  end
end
