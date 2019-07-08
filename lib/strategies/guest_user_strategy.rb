class GuestUserStrategy < LocalStrategy
  def process_searching_user(_user_data)
    Rails.logger.debug { "It's a guest User".cyan }
    ::User.find_by(role: ::Role.find_by(name: :guest))
  end
end
