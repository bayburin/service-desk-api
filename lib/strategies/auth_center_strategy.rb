class AuthCenterStrategy < Warden::Strategies::Base
  def valid?
    access_token.present?
  end

  def authenticate!
    response = Api::V1::AuthCenterApi.user_info(access_token)

    if response.success?
      user = User.authenticate(response.body)
      unless user
        fail!('Не удается пройти авторизацию. Пользователь с соответствующей ролью не найден')
        return
      end
      success!(user)
    else
      Rails.logger.debug { 'Error: Invalid Token'.red }
      fail!('Невалидный токен')
    end
  end

  private

  def access_token
    request.headers['Authorization'].to_s.remove('Bearer ')
  end
end
