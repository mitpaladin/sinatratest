require_relative 'spec_helper'
require_relative '../lib/sinatratest.rb'

require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'capybara_minitest_spec'

Capybara.app = app
Capybara.javascript_driver = :poltergeist

module MiniTest
  class Spec
    include Capybara::DSL
  end
end

module Capybara
  # session for feature testing
  class Session
    def params
      Hash[*URI.parse(current_url).query.split(/\?|=|&/)]
    end
  end
end
