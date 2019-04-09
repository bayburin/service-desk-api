require 'net/http'

module Api
  module V1
    class UsersController < BaseController
      before_action :doorkeeper_authorize!

      def info
        @user_info = ::Api::V1::Doorkeeper::UserInfo.new(doorkeeper_token)

        if @user_info.run
          render json: @user_info.data
        else
          render json: { message: @user_info.errors.full_messages.join('. ') }, status: @user_info.error[:status]
        end
      end

      def owns
        uri = URI("#{ENV['SVT_NAME']}/user_isses/#{current_user.id_tn}/items")

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          req = Net::HTTP::Get.new(uri)
          ::Rails.logger.info 'Получение списка техники для текущего пользователя'
          http.request(req)
        end

        render json: UserOwns.new(JSON.parse(response.body), Service.where(is_sla: true)), serializer: UserOwnsSerializer, status: response.code
      end
    end
  end
end
