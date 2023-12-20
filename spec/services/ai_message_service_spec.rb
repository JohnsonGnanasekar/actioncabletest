# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AiMessageService, type: :service do
  let(:user) { create(:user) }
  let(:message) { create(:message, user: user) }

  describe '#initialize' do
    it 'initializes with a user message' do
      ai_message_service = AiMessageService.new(message: message)
      expect(ai_message_service.instance_variable_get(:@user)).to eq(user)
    end
  end

  describe '#process' do
    let(:ai_message_service) { AiMessageService.new(message: message) }

    before do
      allow(RestClient).to receive(:post).and_return(double(body: '{"results": [{"history": {"visible": [["", "AI response"]]}}]}'))
      allow(ActionCable.server).to receive(:broadcast)
    end

    it 'builds message history and handles AI response' do
      expect(ai_message_service).to receive(:build_messages_history).and_call_original
      expect(ai_message_service).to receive(:handle_ai_response).and_call_original
      ai_message_service.process
    end

    it 'broadcasts the AI response to the chat channel' do
      ai_message_service.process
      expect(ActionCable.server).to have_received(:broadcast).with("chat_channel", message: "AI response")
    end
  end

  describe '#build_messages_history' do
    let(:ai_message_service) { AiMessageService.new(message: message) }

    it 'adds LLM format for the first assistant message' do
      assistant_message = create(:message, user: user, role: 'Assistant', body: 'Assistant response')
      ai_message_service.send(:build_messages_history, ai_message_service.instance_variable_get(:@json_data))

      expect(ai_message_service.instance_variable_get(:@json_data)['history']['internal']).to eq([
                                                                                                   ["<|BEGIN-VISIBLE-CHAT|>", "Assistant response"]
                                                                                                 ])
      expect(ai_message_service.instance_variable_get(:@json_data)['history']['visible']).to eq([
                                                                                                  ["", "Assistant response"]
                                                                                                ])
    end
  end
end

