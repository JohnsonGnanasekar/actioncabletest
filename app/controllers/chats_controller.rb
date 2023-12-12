class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    unless Message.where(user_id: current_user.id).exists?
      current_user.messages.create(role: "Assistant", body: "Hi, How can i help you ?")
    end
    @messages = Message.where(user_id: current_user.id).order(:created_at)
  end
end
