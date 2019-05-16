class AuthCenterStrategy < Warden::Strategies::Base
  def valid?
    access_token.present?
  end

  def authenticate!
    response = Api::V1::AuthCenterApi.user_info(access_token)

    if response.status == 200
      user = User.new
      attributes = response.body.select { |key, _val| user.respond_to?(key.to_sym) }
      user.assign_attributes(attributes)
      success!(user)
    else
      fail!('Невалидный токен')
    end
  end

  private

  def access_token
    request.headers['Authorization'].to_s.remove('Bearer ')
  end
end
