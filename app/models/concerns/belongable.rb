module Belongable
  def belongs_to?(user)
    responsible_users.map(&:tn).include?(user.tn)
  end
end
