class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation
      .includes(:listing, :buyer, :seller)
      .for_user(current_user)
      .order(Arel.sql("COALESCE(last_message_at, created_at) DESC"))
  end

  def show
    @conversation = Conversation.find(params[:id])
    unless [@conversation.buyer_id, @conversation.seller_id].include?(current_user.id)
      redirect_to conversations_path, alert: "Not allowed." and return
    end
    @message = Message.new
  end

  def create
    listing = Listing.friendly.find(params[:listing_id])
    if listing.user_id == current_user.id
      redirect_to listing, alert: "You can’t message yourself." and return
    end

    convo = Conversation.find_or_create_by!(listing: listing, buyer: current_user) do |c|
      c.seller = listing.user
    end

    redirect_to conversation_path(convo)
  end
end
