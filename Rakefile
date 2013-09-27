# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'active_record'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "active_hash_fields"
  gem.homepage = "http://github.com/snitko/active_hash_fields"
  gem.license = "MIT"
  gem.summary = %Q{Adds nested fields to an AR model}
  gem.description = %Q{Adds nested fields to an AR model stored in a serialized field as hash}
  gem.email = "roman.snitko@gmail.com"
  gem.authors = ["Roman Snitko"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "active_hash_fields #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

dbconfig = YAML::load(File.open('db/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

namespace :db do

  task :migrate do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate File.dirname(__FILE__) + '/db/migrations', ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    ActiveRecord::SchemaDumper.dump ActiveRecord::Base.connection, File.open(File.dirname(__FILE__) + '/db/schema.rb', 'w')
  end

  task :rollback do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.down File.dirname(__FILE__) + '/db/migrations', ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    ActiveRecord::SchemaDumper.dump ActiveRecord::Base.connection, File.open(File.dirname(__FILE__) + '/db/schema.rb', 'w')
  end

end
