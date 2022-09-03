require 'rom'
require 'rom-sql'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    ROM::SQL::RakeSupport.env = ROM.container(:sql, 'postgres://localhost:5432/dry_course', username: 'dry_user', password: ENV['PG_PASSWORD'])
  end
end