require_relative 'spec_helper'

  describe "my app" do
    it "should return a UI" do
      get '/'
      last_response.ok?
    end
  end



