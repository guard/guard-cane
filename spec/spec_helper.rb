ENV['RUBY_ENV'] ||= 'test'

require 'guard/compat/test/helper'
require 'guard/cane'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = :random
end

