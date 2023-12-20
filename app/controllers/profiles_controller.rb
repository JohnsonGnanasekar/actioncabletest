class ProfilesController < ApplicationController
  before_action :authenticate_user!
  def index
    @profiles = Profile.all
    @profiles = @profiles.filter_by_gender(params[:gender]) if params[:gender].present?
    @profiles = @profiles.filter_by_category(params[:category]) if params[:category].present?
    @profiles = @profiles.page(params[:page]).per(20)
  end
end
