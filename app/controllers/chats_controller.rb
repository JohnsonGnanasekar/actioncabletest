# frozen_string_literal: true
# ChatsController manages the chat functionality, displaying messages and handling user interactions.
class ChatsController < ApplicationController
  # Ensures that the user is authenticated before accessing any actions in this controller.
  before_action :authenticate_user!

  # Index action displays the chat messages for the current user.
  def index
    # Check if the current user has no messages, and if so, create an initial welcome message.
    unless Message.where(user_id: current_user.id).exists?
      current_user.messages.create(role: "Assistant", body: "Hi, How can i help you ?")
    end
    # Retrieve and order messages for the current user to display in the chat.
    @messages = Message.where(user_id: current_user.id).order(:created_at)
  end
end
