Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = 'ActionController::API'
  config.lograge.keep_original_rails_log = true
  config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/#{Rails.env}.lograge.log"
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.custom_options = lambda do |event|
    {
      params: event.payload[:params].except(:controller, :action, :format, :id),
      time: Time.zone.now.strftime('%d.%m.%Y %H:%M'),
      remote_ip: event.payload[:remote_ip]
    }
  end
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_tn: controller.current_user.try(:tn),
      user_fio: controller.current_user.try(:fio)
    }
  end
end