class Level < ActiveRecord::Base
  validates :level, :title,  :from, :to, presence: true
  validates :title, :level, uniqueness: true
  validate :check_range, if: proc { to.present? && from.present? }

  private

  def check_range
    errors.add(:to, I18n.t('.invalid_range')) if to <= from
  end
end
