require 'capistrano/setup'
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
# For documentation on these, see for example:
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
