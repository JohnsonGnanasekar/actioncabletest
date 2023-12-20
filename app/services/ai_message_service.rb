# frozen_string_literal: true

# The AiMessageService class encapsulates the logic for processing user messages,
# interacting with the AI, and handling background job processing.
class AiMessageService
  include LoadBalancer

  # Initializes a new instance of AiMessageService with a user message.
  #
  # @param [Message] message - The user message to be processed.
  def initialize(message:)
    @user = message.user
    @json_data = {
      your_name: @user.email,
      user_input: message.body,
      name1: @user.email,
      name2: 'AI',
      greeting: 'Hello',
      context: 'Creativity',
      character: 'Example'
    }
  end

  # Processes the user message, interacts with the AI, and broadcasts the AI's response.
  def process
    @json_data = build_messages_history(@json_data)
    response = RestClient.post(next_server.url, @json_data.to_json, content_type: :json, accept: :json)
    handle_ai_response(response)
  end

  private

  # Builds the message history for the AI interaction using the provided JSON data.
  #
  # @param [Hash] json_data - The JSON data containing information about the AI interaction.
  # @return [Hash] - The updated JSON data with message history.
  def build_messages_history(json_data)
    json_data["history"] ||= {}
    json_data["history"]["internal"] ||= []
    json_data["history"]["visible"] ||= []
    previous_message = ""
    @user.messages.order(:created_at).each_with_index do |message, index|
      if message.role == "Assistant"
        # If it's the first message from the assistant, we
        # add the LLM format required
        if index == 0
          json_data["history"]["internal"] << ["<|BEGIN-VISIBLE-CHAT|>", message.body]
          json_data["history"]["visible"] << ["", message.body]
        else
          json_data["history"]["internal"] << [previous_message, message.body]
          json_data["history"]["visible"] << [previous_message, message.body]
        end
        previous_message = ""
      else
        previous_message = message.body
      end
    end
    json_data
  end

  # Handles the AI's response, creates a new message, and broadcasts it to the chat channel.
  #
  # @param [RestClient::Response] response - The response received from the AI API.
  def handle_ai_response(response)
    output = JSON.parse(response.body) rescue nil
    return unless output

    message = User.last.messages.create(role: "Assistant", body: output["results"][0]["history"]["visible"].last.last)
    ActionCable.server.broadcast "chat_channel", message: message.body
  end
end