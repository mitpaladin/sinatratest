
require_relative 'spec_helper'

describe 'the main application' do
  it 'should respond to the HTTP GET method for the root path' do
    get '/'
    expect(last_response).must_be :ok?
  end
end
