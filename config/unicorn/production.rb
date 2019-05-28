# paths
app_path = "/var/www/service-desk-api"
working_directory "#{app_path}"
pid "#{app_path}/tmp/pids/unicorn.pid"

# listen
# Путь к unix сокету, с которым будет работать nginx
# backlog - кол-во workers, которые могут быть запущены сервером приложений
# listen "/tmp/unicorn.sd-api.sock", backlog: 64
listen "/var/sockets/unicorn.service-desk-api.sock", backlog: 64

# logging
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

# workers
# Количество master-процессов, за каждым из которых стоит n workers.
worker_processes 2

# Чтобы unicorn стартовал с правильными гемами
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/Gemfile"
end

# Загрузка приложения в память, для более быстрого старта workers
# Zero-downtime deploy
preload_app true

before_fork do |server, worker|
  # Если preload_app установлен в true
  # Необходимо перед созданием воркера разорвать соединение с БД
  # Таким образом у каждого воркера будет свое соединение с БД
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Код, который отвечает за zero-downtime deploy
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # Something else
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
  ThinkingSphinx::Connection.pool.clear
end
