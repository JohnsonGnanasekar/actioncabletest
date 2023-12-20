# frozen_string_literal: true
# ChatChannel class represents an Action Cable channel for handling real-time chat functionality.
# It allows clients to subscribe, unsubscribe, and receive messages in real-time.
class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to the "chat_channel" stream when a client connects to this channel
    stream_from "chat_channel"
  end

  def unsubscribed
    # Perform any necessary cleanup when the client unsubscribes from this channel
    # (e.g., removing references, stopping background jobs, etc.)
  end

  def receive(data)
    # When a client sends a message, create a new message associated with the last user
    # and enqueue a background job to process the message asynchronously
    message = User.last.messages.create(role: "You", body: data["body"])
    MessageProcessorJob.perform_async(message.id)
  end
end
