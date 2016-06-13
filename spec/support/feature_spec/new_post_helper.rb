require_relative 'helper_base'
require_relative 'post_helper_support/post_creator_data'

# Feature-spec support class to create and publish a new post.
class FeatureSpecNewPostHelper < FeatureSpecHelperBase
  extend Forwardable

  def_delegator :@data, :step, :step

  def initialize(spec_obj, data = PostHelperSupport::PostCreatorData.new)
    super
  end

  def create_image_post
    create_post
  end

  def create_text_post
    create_post(false)
  end

  private

  def create_post(image_post = true)
    setup_post_fields
    fill_in_new_post_form image_post
  end

  def fill_in_new_post_form(image_post)
    s.instance_eval do
      fill_in 'title', with: @post_title
      fill_in 'body', with: @post_body
      fill_in 'image_url', with: @image_url if image_post
      click_on 'Create!'
    end
  end

  def setup_post_fields
    s.instance_exec(data) do |data|
      @post_title = data.post_title
      @post_body = data.post_body
      @image_url ||= 'http://fc01.deviantart.net/fs70/f/2014/113/e/6/' \
          'dreaming_of_another_reality_by_razielmb-d7fgl3s.png'
    end
  end
end