class SearchesController < ApplicationController
  def all
    @organizations = searches(Organization, :organizations_page)
    @gift_items = searches(GiftItem, :gift_items_page)
    @wish_items = searches(WishItem, :wish_items_page)
  end

  private

  def searches(model, pagination_param)
    model.search(params[:query]).page(params[pagination_param]).per(4)
  end
end
