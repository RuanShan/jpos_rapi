lock '3.2.1'

set :application, 'rails4eg'
set :repo_url,  'git@github.com:jehughes/rails4-example.git'
set :deploy_to, "/home/username/webapps/#{fetch(:application)}"
set :tmp_dir, '/home/username/tmp'

set :format, :pretty
set :log_level, :info

set :scm, :git
set :scm_username, 'username'
set :scm_verbose, true

set :pty, true
set :keep_releases, 3
set :use_sudo, false

SSHKit.config.command_map[:rake]  = "bundle exec rake"

set :default_env,
    'PATH' => "#{deploy_to}/gems/bin:#{deploy_to}/bin:#{ENV['PATH']}",
    'GEM_HOME' => "#{deploy_to}/gems",
    'BUNDLE_PATH' => "#{deploy_to}/gems"

set :linked_files, %w{config/database.yml config/secrets.yml config/private.yml config/locales/en.private.yml}
set :linked_dirs, %w{bin log tmp}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        with rails_env: :production do
          execute :rake, 'tmp:cache:clear'
        end
      end
    end
  end

end
