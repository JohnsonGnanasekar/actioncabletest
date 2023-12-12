# frozen_string_literal: true

class AiMessageService
  include LoadBalancer

  def initialize(message:)
    username = message.user.email
    @json_data = {
      your_name: username,
      user_input: message.body,
      name1: username,
      name2: 'AI',
      greeting: 'Hello',
      context: 'Creativity',
      character: 'Example'
    }
  end

  def process
    @json_data = build_messages_history(@json_data)
    response = RestClient.post(next_server.url, @json_data.to_json, content_type: :json, accept: :json)
    output = JSON.parse(response.body)
    puts output
    message = User.last.messages.create(role: "Assistant", body: output["results"][0]["history"]["visible"].last.last)
    ActionCable.server.broadcast "chat_channel", message: message.body
  end

  private

  def build_messages_history(json_data)
    json_data["history"] ||= {}
    json_data["history"]["internal"] ||= []
    json_data["history"]["visible"] ||= []
    previous_message = ""
    Message.all.order(:created_at).each_with_index do |message,
      index|
      if message.role == "Assistant"
       # If it's the first message from the assistant, we
       # add the LLM format required
       if index == 0
       json_data["history"]["internal"] << ["<|BEGIN-VISIBLE-CHAT|>", message.body] if index == 0
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

end
