class GiftItemsController < ApplicationController
  def index
    @gift_items = params[:query].present? ? GiftItem.search(params[:query]) : GiftItem.all
  end
end
