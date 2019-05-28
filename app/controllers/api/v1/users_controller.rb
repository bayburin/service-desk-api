require 'net/http'

module Api
  module V1
    class UsersController < BaseController
      def info
        render json: current_user
      end

      def owns
        items = SvtApi.items(current_user).body
        services = Service.extend(Scope).visible

        render json: UserOwns.new(items, services), serializer: UserOwnsSerializer
      end
    end
  end
end
