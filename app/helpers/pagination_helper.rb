module PaginationHelper

  def paginate_scope(scope, per = 15)
    scope.page(params[:page] || 1).per(per)
  end

end
