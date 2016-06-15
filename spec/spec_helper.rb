ENV['RACK_ENV'] = 'test'

require 'rack/test'
require_relative '../lib/sinatratest.rb'
require 'minitest/autorun'

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
