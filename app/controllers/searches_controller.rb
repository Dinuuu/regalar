class SearchesController < ApplicationController
  def all
    @organizations = Organization.search(params[:query]).page(params[:organizations_page]).per(4)
    @gift_items = GiftItem.search(params[:query]).page(params[:gift_items_page]).per(4)
    @wish_items = WishItem.search(params[:query]).page(params[:wish_items_page]).per(4)
  end
end