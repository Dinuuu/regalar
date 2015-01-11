# encoding: utf-8
module CommentsHelper
  def build_association_chain
    Array.new(association_chain) << @comment
  end
end
