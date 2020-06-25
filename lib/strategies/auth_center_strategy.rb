class AuthCenterStrategy < Warden::Strategies::Base
  def valid?
    access_token.present?
  end

  def authenticate!
    user_info = Api::V1::AuthCenter::AccessToken.get(access_token)

    if user_info
      user = User.authenticate(user_info)

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
