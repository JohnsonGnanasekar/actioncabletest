# frozen_string_literal: true
# ProfilesController manages the display of user profiles with filtering and pagination.

class ProfilesController < ApplicationController
  # Ensures that the user is authenticated before accessing any actions in this controller.
  before_action :authenticate_user!

  # Index action displays user profiles with optional filtering and pagination.
  def index
    # Retrieve all profiles by default.
    @profiles = Profile.all

    # Filter profiles by gender if the 'gender' parameter is present.
    @profiles = @profiles.filter_by_gender(params[:gender]) if params[:gender].present?

    # Filter profiles by category if the 'category' parameter is present.
    @profiles = @profiles.filter_by_category(params[:category]) if params[:category].present?

    # Paginate the profiles with 20 profiles per page.
    @profiles = @profiles.page(params[:page]).per(20)
  end
end
