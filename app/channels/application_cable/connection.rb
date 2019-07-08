module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.fio
    end

    protected

    def find_verified_user
      response = Api::V1::AuthCenterApi.user_info(request.parameters[:access_token])

      if response.success? && user = User.authenticate(response.body)
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
