class SearchesController < ApplicationController
  def all
    @organizations = searches(Organization, :organizations_page)
    @gift_items = searches(GiftItem, :gift_items_page).not_eliminated
    @wish_items = searches(WishItem, :wish_items_page).not_eliminated.not_paused
  end

  private

  def searches(model, pagination_param)
    model = model.search(params[:query]) if params[:query].present?
    model.page(params[pagination_param]).per(4)
  end
end
