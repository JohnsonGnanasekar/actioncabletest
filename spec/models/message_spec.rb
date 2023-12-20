# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should belong_to(:user) }
    it { should validate_presence_of(:body) }
  end

  describe 'attributes' do
    it 'has user_id attribute' do
      message = Message.new(user_id: 1)
      expect(message).to have_attributes(user_id: 1)
    end
  end


  describe 'factory' do
    it 'is valid' do
      message = build(:message)
      expect(message).to be_valid
    end
  end
end
