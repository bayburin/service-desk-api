class ApplicationController < ActionController::API
  before_action :log_ip

  def welcome
    render :nothing
  end

  def append_info_to_payload(payload)
    super
    payload[:remote_ip] = request.env['HTTP_X_FORWARDED_FOR']
  end

  protected

  def log_ip
    logger.info "Request from IP: #{request.env['HTTP_X_FORWARDED_FOR']}".cyan
  end
end
