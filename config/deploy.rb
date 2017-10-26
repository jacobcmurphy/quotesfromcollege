# config valid only for current version of Capistrano
lock '3.7.2'

set :repo_url,    'https://github.com/jacobcmurphy/quotesfromcollege.git'
set :application, 'quotesfromcollege'
set :user,        'deploy'

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa) }
set :rbenv_ruby, '2.4.0'
set :thin_config_path, -> { "config/thin/#{fetch(:stage)}.yml" }
set :keep_releases, 5
set :bundle_binstubs, nil

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :thin do
  desc 'Create Directories for Thin server'
  task :make_dirs do
    on roles(:app) do
      # TODO
    end
  end

  before :start, :make_dirs
end

after 'deploy:publishing', 'thin:restart'

