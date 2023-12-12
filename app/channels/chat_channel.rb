class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "chat_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    message = User.last.messages.create(role: "You", body: data["body"])
    MessageProcessorJob.perform_async(message.id)
  end
end
