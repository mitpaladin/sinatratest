require 'test_helper'
require 'sinatra'

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "my app" do
    it "should return a UI" do
      get '/'
      last_response.ok?
    end
  end



