class ApplicationService
  include ActiveModel::Validations

  attr_reader :data, :error, :doorkeeper_token

  def initialize(*_args)
    @data = {}
    @error = {}
  end

  def auth_center_token
    AuthCenterToken.where(resource_owner_id: doorkeeper_token.resource_owner_id).last if doorkeeper_token
  end
end
