# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Caching Mechanism', type: :integration do
  let(:user) { create(:user) }
  let(:message1) { create(:message, user: user, role: 'User') }
  let(:message2) { create(:message, user: user, role: 'User') }
  let(:message3) { create(:message, user: user, role: 'User') }

  let(:ai_message_services) do
    [
      AiMessageService.new(message: message1),
      AiMessageService.new(message: message2),
      AiMessageService.new(message: message3)
    ]
  end

  let(:redis) { Redis.new }

  before(:suite) do
    # Clear Redis before each example in this spec file
    Redis.new.flushdb
  end

  describe AiMessageService do
    context 'when processing the 1st message' do
      it 'updates the server cache and index' do
        # Expect the cache to be updated after processing the message
        expect {
          ai_message_services[0].process
        }.to change { redis.get('load_balancer:current_index') }.from('1')
        expect(redis.get('load_balancer:current_index')).to eq('0')
      end
    end

    context 'when processing the 2nd message' do
      it 'updates the server cache and index' do
        # Expect the cache to be updated after processing the message
        expect {
          ai_message_services[1].process
        }.to change { redis.get('load_balancer:current_index') }.from('0')
        expect(redis.get('load_balancer:current_index')).to eq('1')
      end
    end

    context 'when processing the 3rd message' do
      it 'updates the server cache and index' do
        # Expect the cache to be updated after processing the message
        expect {
          ai_message_services[2].process
        }.to change { redis.get('load_balancer:current_index') }.from('1')
        expect(redis.get('load_balancer:current_index')).to eq('0')
      end
    end
  end

  describe LoadBalancer do
    context 'when retrieving the next server' do
      it 'uses a round-robin mechanism and updates the index in cache' do


        # Retrieve servers and the next server multiple times
        servers = []
        3.times do
          server = LoadBalancer.next_server
          servers << server[:name]
        end

        # Expect the servers to be retrieved in round robin way and the index to be updated in cache accordingly
        expect(servers).to eq(%w[server-1 server-2 server-1])
        expect(redis.get('load_balancer:current_index')).to eq('1')
      end
    end
  end
end
