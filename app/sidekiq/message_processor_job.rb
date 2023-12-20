# MessageProcessorJob is a Sidekiq job responsible for processing messages asynchronously.
class MessageProcessorJob
  # Include the Sidekiq::Job module to define a Sidekiq job.
  include Sidekiq::Job

  # Perform method is called when the job is executed.
  # It processes a message using the AiMessageService.
  def perform(message_id)
    # Instantiate AiMessageService with the message corresponding to the given message_id.
    # Call the process method to perform the message processing logic.
    AiMessageService.new(message: Message.find(message_id)).process
  end
end
