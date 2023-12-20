# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:password).is_at_least(6).on(:create) }
  end

  describe 'associations' do
    it { should have_many(:messages) }
  end

  describe 'devise modules' do
    it { should have_db_column(:email).of_type(:string).with_options(null: false, default: '') }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: '') }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_index(:email).unique }
    it { should have_db_index(:reset_password_token).unique }
  end
end
