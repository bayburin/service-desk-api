module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_user!, only: :token
      skip_after_action :track_action

      def token
        token_response = Api::V1::AuthCenterApi.access_token(params[:code])

        if token_response.success?
          access_token = token_response.body['access_token']
          user_info_response = Api::V1::AuthCenterApi.user_info(access_token)
          AuthCenter::AccessToken.set(access_token, user_info_response.body)

          render json: token_response.body
        else
          render json: { message: 'Ошибка авторизации' }, status: token_response.status
        end
      end

      def revoke
        access_token = request.headers['Authorization'].to_s.remove('Bearer ')
        result = AuthCenter::AccessToken.del(access_token)

        if result == 1
          render json: { message: 'Ok' }
        else
          render json: { message: 'Токен не найден' }, status: :unprocessable_entity
        end
      end
    end
  end
end
