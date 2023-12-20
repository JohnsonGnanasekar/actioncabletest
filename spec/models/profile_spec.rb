# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:name) }
  end

  describe 'database columns' do
    it { should have_db_column(:gender).of_type(:string).with_options(null: false) }
    it { should have_db_column(:category).of_type(:string).with_options(null: false) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
  end


  describe 'scopes' do
    it 'has a scope for filtering by gender' do
      male_profile = Profile.filter_by_gender('male').first
      female_profile = Profile.filter_by_gender('female').first

      expect(male_profile.gender).to eq('male')
      expect(female_profile.gender).to eq('female')
    end

    it 'has a scope for filtering by gender' do
      realistic_profile = Profile.filter_by_category('realistic').first
      anime_profile = Profile.filter_by_category('anime').first

      expect(realistic_profile.category).to eq('realistic')
      expect(anime_profile.category).to eq('anime')
    end
  end

  describe 'seeded' do
    it 'should have 100 profiles after seeding' do
      expect(Profile.count).to eq(100)
    end
  end


end

