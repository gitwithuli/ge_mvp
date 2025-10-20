# app/controllers/favorites_controller.rb
class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing

  def create
    current_user.favorites.find_or_create_by!(listing: @listing)
    redirect_back fallback_location: search_path, notice: "Saved."
  end

  def destroy
    current_user.favorites.where(listing: @listing).delete_all
    redirect_back fallback_location: search_path, notice: "Removed."
  end

  private

  def set_listing
  @listing = Listing.friendly.find(params[:listing_id])
  end
end