# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

server 'service-desk', user: 'deployer', roles: %w[web app db]

set :repo_url,          'git@gitlab.iss-reshetnev.ru:714/7141/service-desk-api.git'
set :ssh_options,       forward_agent: false, user: 'deployer'
set :use_sudo,          false
set :rbenv_ruby,        '2.5.5'
set :rbenv_map_bins,    fetch(:rbenv_map_bins).to_a.concat(%w[rake gem bundle ruby rails])
set :linked_files,      %w[config/database.yml config/thinking_sphinx.yml .env]
set :linked_dirs,       %w[log tmp/pids tmp/cache vendor/bundle storage/uploads storage/sphinx]
set :sneakers_workers,  ['Messaging::CaseEventWorker']

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:stop'
      invoke 'unicorn:start'
    end
  end

  after :publishing, :restart
end
