require_relative '../feature_helper'

describe 'App' do
  it 'allows creation of new articles' do
    visit '/'

    fill_in 'body', with: 'Test bodytext1'
    fill_in 'title', with: 'Test title1'
    fill_in 'keywords', with: 'keyword1, keyword2'
    click_button 'Create!'

    page.must_have_content 'Test bodytext1'
    page.must_have_content 'Test title1'
    page.must_have_content 'keyword1'
    page.must_have_content 'keyword2'

    first(:link, 'edit').click
    first(:link, 'Delete').click
    click_button 'Delete!'
  end
  it 'increments keyword count properly' do
    visit '/'

    fill_in 'body', with: 'Test bodytext1'
    fill_in 'title', with: 'Test title1'
    fill_in 'keywords', with: 'keyword1, keyword2'
    click_button 'Create!'

    fill_in 'body', with: 'Test bodytext2'
    fill_in 'title', with: 'Test title2'
    fill_in 'keywords', with: 'keyword2, keyword3'
    click_button 'Create!'

    keyw_ary = page.find('#keywords_array')
    keyw_ary.text.must_have_content(/1=>(.*)keyword1(.*)/)
    keyw_ary.text.must_have_content(/2=>(.*)keyword2(.*)/)
    keyw_ary.text.must_have_content(/1=>(.*)keyword3(.*)/)

    first(:link, 'edit').click
    first(:link, 'Delete').click
    click_button 'Delete!'

    first(:link, 'edit').click
    first(:link, 'Delete').click
    click_button 'Delete!'
  end
end
