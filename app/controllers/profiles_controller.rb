class ProfilesController < ApplicationController
  before_action :authenticate_user!
  def index
    @profiles = Profile.all
    @profiles = @profiles.where(gender: params[:gender]) if params[:gender].present?
    @profiles = @profiles.where(category: params[:category]) if params[:category].present?
    @profiles = @profiles.page(params[:page]).per(20)
  end
end
