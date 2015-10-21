require 'spec_helper'

ENV['MOCK_SYSDIG'] ||= 'true'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sysdig'

Bundler.require(:test)

Dir[File.expand_path('../{matchers,shared,factories,support}/**/*.rb', __FILE__)].each { |f| require f }

if 'true' == ENV['MOCK_SYSDIG']
  Sysdig.mock!
end

RSpec.configure do |config|
  config.backtrace_exclusion_patterns << /\/gems\/rspec/
end
