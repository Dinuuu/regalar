module CampaignCategoryHelper

  def category_icon(cat)
    if cat.to_s == 'health'
      'glyphicons/glyphicons_298_hospital.png'
    elsif cat.to_s == 'social'
      'glyphicons/glyphicons_043_group.png'
    elsif cat.to_s == 'education'
      'glyphicons/glyphicons_071_book.png'
    end
  end
end
