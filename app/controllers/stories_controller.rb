class StoriesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :check_for_blog_created!

  expose_decorated(:story)
  expose_decorated(:stories) { current_user.stories }

  STORY_PARAMS = %i[title url content published blog_id].freeze

  def index; end

  def new; end

  def create
    story.user = current_user
    story.save

    respond_with story
  end

  def show; end

  def update
    story.update(story_params)
    story.save

    respond_with story
  end

  private

  def story_params
    params.require(:story).permit(*STORY_PARAMS)
  end

  def check_for_blog_created!
    return unless user_signed_in?

    redirect_to(new_users_blog_path, notice: t("blogs.create_first_blog")) unless current_user.blogs.any?
  end
end
