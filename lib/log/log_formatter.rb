class MessageFormatter < ActiveSupport::Logger::SimpleFormatter
  def call(severity, time, _progname, msg)
    formatted_severity = format('%-5s', severity.to_s)
    formatted_time = time.strftime('%d.%m.%Y %H:%M:%S.%L')

    "[##{$$} #{formatted_time} #{formatted_severity}] : #{msg}\n"
  end
end
