class ListingsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update mine promote]
  before_action :set_listing, only: %i[show edit update promote]
  before_action :authorize_owner!, only: %i[edit update promote]

  def index
    @listings = Listing
      .includes(:category, :location)
      .order(Arel.sql('promoted_until DESC NULLS LAST, id DESC'))
      .limit(48)
  end

  def show; end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user ||= current_user
    if @listing.save
      redirect_to @listing, notice: "Listing created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @listing.update(listing_params)
      redirect_to @listing, notice: "Listing updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Owner's listings
  def mine
    @listings = current_user.listings
      .includes(:category, :location)
      .order(Arel.sql('promoted_until DESC NULLS LAST, id DESC'))
  end

  # Owner-only: boost visibility for 7 days
  def promote
    @listing.update!(promoted_until: 7.days.from_now)
    redirect_to @listing, notice: "Promoted for 7 days."
  end

  private
    def set_listing
      @listing = Listing.friendly.find(params[:id])
    end

    def authorize_owner!
      redirect_to @listing, alert: "Not allowed." unless @listing.user_id == current_user.id
    end

    def listing_params
      params.require(:listing).permit(
        :title, :description, :price_cents, :currency, :status, :condition,
        :category_id, :location_id, :promoted_until, :slug,
        photos: []
      )
    end
end