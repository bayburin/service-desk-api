Rails.application.configure do
  config.action_mailer.smtp_settings = {
    address: ENV['ACTION_MAILER_SERVER'],
    port: 25,
    user_name: ENV['ACTION_MAILER_USERNAME'],
    password: ENV['ACTION_MAILER_PASSWORD'],
    authentication: "plain",
    openssl_verify_mode: 'none'
  }
end
