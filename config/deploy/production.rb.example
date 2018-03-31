set :stage, :production
set :rails_env, :production
set :branch, :master

set :user, 'username'

role :web, 'webXXX.webfaction.com'
role :app, 'webXXX.webfaction.com'
role :db,  'webXXX.webfaction.com', primary: true

server 'webXXX.webfaction.com', user: 'username', roles: %w(web app db),
                                ssh_options: {keys: %w(~/.ssh/id_rsa), 
                                              forward_agent: true, 
                                              auth_methods: %w(publickey)}

set :ssh_options, {
  # verbose: :debug
}
