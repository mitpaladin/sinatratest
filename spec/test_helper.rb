$LOAD_PATH.unshift File.expand_path('../', __FILE__)

ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/unit'
require 'rack/test'

