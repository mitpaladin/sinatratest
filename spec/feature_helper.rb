require_relative 'spec_helper'
require_relative '../lib/sinatratest.rb'

require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'
require 'capybara_minitest_spec'

Capybara.app = app
Capybara.default_driver = :webkit

class MiniTest::Spec
  include Capybara::DSL
end

class Capybara::Session
  def params
    Hash[*URI.parse(current_url).query.split(/\?|=|&/)]
  end
end