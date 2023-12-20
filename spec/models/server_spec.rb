# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Server, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'database columns' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:url).of_type(:string).with_options(null: false) }
  end
end

