RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers

  # == Mock Framework
  config.mock_with :rspec

  require 'active_record'
  require File.dirname(__FILE__) + '/../lib/active_hash_fields'

  config.before(:suite) do
    dbconfig = YAML::load(File.open(File.dirname(__FILE__) + '/../db/database.yml'))
    ActiveRecord::Base.establish_connection(dbconfig)
  end

  config.after(:suite) do
    conn = ActiveRecord::Base.connection
    tables = conn.execute("SELECT name FROM sqlite_master WHERE type = 'table'").map { |r| r[0] }
    tables.delete "schema_migrations"
    tables.each { |t| conn.execute("DELETE FROM #{t};") }
    tables.each { |t| conn.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='#{t}';") }
  end

end
