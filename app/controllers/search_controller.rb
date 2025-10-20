class SearchController < ApplicationController
  def index
    @q = params.permit(:q, :category_id, :location_id, :min_price, :max_price, :condition)

    @categories = Category.order(:name)
    @locations  = Location.order(:name)

    scope = Listing.includes(:category, :location)
                   .order(Arel.sql('promoted_until DESC NULLS LAST, id DESC'))

    if @q[:q].present?
      scope = scope.where("title ILIKE :q OR description ILIKE :q", q: "%#{@q[:q]}%")
    end
    scope = scope.where(category_id: @q[:category_id]) if @q[:category_id].present?
    scope = scope.where(location_id:  @q[:location_id]) if @q[:location_id].present?

    if @q[:condition].present?
      # we renamed enum to avoid 'new' collision: {brand_new: 0, used: 1}
      scope = scope.where(condition: Listing.conditions[@q[:condition]])
    end

    if @q[:min_price].present?
      scope = scope.where("price_cents >= ?", @q[:min_price].to_i * 100)
    end
    if @q[:max_price].present?
      scope = scope.where("price_cents <= ?", @q[:max_price].to_i * 100)
    end

    @listings = scope.limit(48)
  end
end