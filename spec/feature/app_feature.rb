require_relative '../feature_helper'

describe 'App' do
  it 'shows a site' do
    visit '/'

    fill_in 'body', with: 'Test bodytext'
    fill_in 'title', with: 'Test title'
    click_button 'Create!'

    page.must_have_content 'Test bodytext'
  end
end
