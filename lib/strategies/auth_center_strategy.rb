class AuthCenterStrategy < Warden::Strategies::Base
  attr_reader :user

  def valid?
    access_token.present?
  end

  def authenticate!
    response = Api::V1::AuthCenterApi.user_info(access_token)

    if response.status == 200
      return unless process_by_local_strategy(response.body)

      attributes = response.body.select { |key, _val| user.respond_to?(key.to_sym) }
      user.assign_attributes(attributes)
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

  def process_by_local_strategy(response_data)
    strategy = ::UserStrategy.new(
      ::ServiceResponsibleUserStrategy.new(
        ::GuestUserStrategy.new
      )
    )

    @user = strategy.check_access(response_data)
  rescue RuntimeError => e
    Rails.logger.debug { "Error: #{e}".red }
    fail!('Не удается пройти авторизацию')
  end
end
