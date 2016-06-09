require 'spec_helper'
require 'sinatra'

  describe "my app" do
    it "should return a UI" do
      get '/'
      last_response.ok?
    end
  end



