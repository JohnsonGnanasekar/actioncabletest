class MessageProcessorJob
  include Sidekiq::Job

  def perform(message_id)
    AiMessageService.new(message: Message.find(message_id)).process
  end
end
