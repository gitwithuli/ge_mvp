class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    return redirect_to conversations_path, alert: "Not allowed." unless participant?

    @message = @conversation.messages.build(message_params.merge(user: current_user))
    if @message.save
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to conversation_path(@conversation) }
      end
    else
      render "conversations/show", status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def participant?
    [@conversation.buyer_id, @conversation.seller_id].include?(current_user.id)
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
