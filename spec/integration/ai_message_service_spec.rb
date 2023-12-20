# frozen_string_literal: true

require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.describe AiMessageService, type: :integration do
  let(:user) { create(:user) }
  let(:message) { create(:message, user: user, role: 'You', body: 'How to know more about my partner?') }

  describe '#process' do
    it 'sends a request to the AI API and handles the response' do
      VCR.use_cassette('ai_message_service_process') do
        expect {
          AiMessageService.new(message: message).process
        }.to change { user.messages.count }.by(2)
      end
    end
  end
end
