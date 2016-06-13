require_relative 'post_helper_support/post_creator_data'
require_relative '../../spec_helper'
require_relative '../../../sinatratest.rb'

require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'
require 'capybara_minitest_spec'

Capybara.app = app
Capybara.default_driver = :webkit

class Capybara::Session
  def params
    Hash[*URI.parse(current_url).query.split(/\?|=|&/)]
  end
end

# Base class for other feature-spec support classes; knows about spec and user
# fields, and actions common to most/all feature specs (setting up user fields,
# for example).
class FeatureSpecHelperBase < MiniTest::Spec
  include Capybara::DSL

  def initialize(spec_obj, data)
    @s = spec_obj
    @data = data
  end

  protected

  attr_reader :data, :s
end