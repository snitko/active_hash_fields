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

end
