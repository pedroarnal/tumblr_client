if ENV['COV'] == '1'
  require 'simplecov'
  SimpleCov.start
end

require 'json'
require 'ostruct'
require_relative '../lib/tumblr_client'
