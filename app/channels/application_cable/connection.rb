module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.fio
    end

    protected

    def find_verified_user
      user_info = Api::V1::AuthCenter::AccessToken.get(request.parameters[:access_token])

      if user_info && user = User.authenticate(user_info)
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
