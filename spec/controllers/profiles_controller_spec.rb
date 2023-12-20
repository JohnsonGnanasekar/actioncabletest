# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  render_views
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns all profiles when no filters are applied' do
      get :index
      expect(assigns(:profiles).to_a).to eq(Profile.all.page(1).per(20).to_a)
    end

    it 'filters profiles by gender' do
      get :index, params: { gender: 'male' }
      expect(assigns(:profiles).to_a).to eq(Profile.filter_by_gender('male').page(1).per(20).to_a)
    end

    it 'filters profiles by category' do
      get :index, params: { category: 'anime' }
      expect(assigns(:profiles).to_a).to eq(Profile.filter_by_category('anime').page(1).per(20).to_a)
    end

    it 'filters profiles by both gender and category' do
      get :index, params: { gender: 'female', category: 'realistic' }
      expected_profiles = Profile.filter_by_gender('female').filter_by_category('realistic').page(1).per(20).to_a
      expect(assigns(:profiles).to_a).to eq(expected_profiles)
    end
  end
end
