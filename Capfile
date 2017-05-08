# Load DSL and Setup Up Stages
require 'capistrano/deploy'
require 'capistrano/setup'
require 'capistrano/rails/migrations'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/puma'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
# Load DSL and Setup Up Stages
