$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'spec'
require 'mocha'
require 'sermont'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end