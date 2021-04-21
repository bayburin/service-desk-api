class Api::V2::ServicesController < Api::V2::BaseController
  def index
    render json: Api::V1::ServicesQuery.new.allowed_to_create_app
  end
end
