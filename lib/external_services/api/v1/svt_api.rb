module Api
  module V1
    class SvtApi
      include Connection

      API_ENDPOINT = ENV['SVT_URL']

      def self.items(current_user, params = {})
        connect.get("user_isses/#{current_user.id_tn}/items", params)
      end
    end
  end
end
