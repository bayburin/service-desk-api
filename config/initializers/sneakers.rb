Sneakers.configure  amqp: "amqp://#{ENV['BUNNY_AMQP_USERNAME']}:#{ENV['BUNNY_AMQP_PASSWORD']}@#{ENV['BUNNY_AMQP_HOST']}",
                    daemonize: true,
                    durable: true,
                    workers: ENV['SNEAKERS_WORKERS'].to_i,
                    threads: ENV['SNEAKERS_THREADS'].to_i,
                    delivery_mode: 2,
                    log: "log/sneakers.log",
                    pid_path: "tmp/pids/sneakers.pid",
                    vhost: ENV['BUNNY_AMQP_VHOST'],
                    env: ENV['RAILS_ENV'],
                    ack: true,
                    heartbeat: 5,
                    timeout_job_after: 1

# Sneakers.logger.level = Logger::INFO