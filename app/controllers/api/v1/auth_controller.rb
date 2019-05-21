module Api
  module V1
    class AuthController < BaseController
      # skip_before_action :authenticate_user!

      def token
        response = Api::V1::AuthCenterApi.access_token(params[:code])

        if response.status == 200
          render json: response.body
        else
          render json: { message: 'Ошибка авторизации' }, status: response.status
        end
      end

      def revoke; end
    end
  end
end
