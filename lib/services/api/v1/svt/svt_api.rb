module Api
  module V1
    module Svt
      class SvtApi
        def self.items(current_user, params = {})
          Api::V1::Svt::Request.get("user_isses/#{current_user.id_tn}/items", params)
        end
      end
    end
  end
end
