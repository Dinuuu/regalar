module PaginationHelper
  def paginate_scope(scope, per = 12)
    Kaminari.paginate_array(scope).page(params[:page] || 1).per(per)
  end
end
