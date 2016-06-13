require_relative '../support/feature_spec/new_post_helper.rb'

describe 'Member can create a draft post and see' do
  before :each do
    data = PostHelperSupport::PostCreatorData.new
    FeatureSpecNewPostHelper.new(self, data).create_image_post
  end

  it 'the confirmation' do
    expect(page).to have_text data.post_body
  end

end # describe 'Member can create a valid image post and see'