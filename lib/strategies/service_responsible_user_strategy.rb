class ServiceResponsibleUserStrategy < LocalStrategy
  def process_checking_access(user_data)
    return unless ::ResponsibleUser.exists?(tn: user_data['tn'])

    Rails.logger.debug { "It's a responsible User".cyan }
    ::User.find_by(role: Role.find_by(name: :service_responsible))
  end
end
