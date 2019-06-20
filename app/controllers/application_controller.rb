class ApplicationController < ActionController::API
  before_action :log_ip

  def welcome
    render :nothing
  end

  protected

  def log_ip
    logger.info "Request from IP: #{request.env['HTTP_X_FORWARDED_FOR']}"
  end
end
