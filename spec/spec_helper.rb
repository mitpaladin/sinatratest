ENV['RACK_ENV'] = 'test'

require 'bundler'

Bundler.setup
Bundler.require

require 'rack/test'  
require_relative '../sinatratest.rb'
require 'minitest/autorun'
require 'minitest'
require 'minitest/spec'
require 'minitest/pride'

include Rack::Test::Methods

def app
  Sinatra::Application
end

# Load the unit helpers
require_relative 'support/unit_helpers.rb'

class UnitTest < MiniTest::Spec
  include UnitHelpers

  register_spec_type(self) do |desc, *addl|
    true if desc.is_a?(Class)
    addl.include? :unit
  end
end