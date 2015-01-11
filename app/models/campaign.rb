# It's a Campaign/Project/Fundriser to raise something.
# Campaigs funding method will work on the bases of milestones.

class Campaign < ActiveRecord::Base

  include PgSearch
  pg_search_scope :search,
                  against: [:name, :description, :short_description],
                  using: { tsearch: { dictionary: 'spanish' } }

  include AASM

  belongs_to :organization
  has_many :perks
  has_many :comments, as: :commentable
  has_many :updates
  has_many :contributions
  has_many :milestones

  accepts_nested_attributes_for :perks, :milestones, reject_if: :all_blank, allow_destroy: true

  CATEGORIES = [:education, :social, :health]

  RECIPIENT = [:individual, :registered_company, :npo_501, :npo, :religious_npo]
  FUNDING_TYPE = [:all, :partial]

  STATES = [:pending, :approved, :rejected, :started_not_funded,
            :closed_funded, :closed_partially_funded, :closed_not_funded]

  validates :category, inclusion: { in: CATEGORIES.map(&:to_s) }, presence: true
  validates :name, :description, :short_description, :locality, :country, presence: true
  validates :minimum, :goal, numericality: { greater_than: 0 }
  validates :deadline, timeliness: { on_or_after: -> { Date.current } }
  validates :minimum, :goal, presence: true

  mount_uploader :main_image, CampaignImageUploader

  after_initialize :default_attributes

  def add_contribution(amount)
    update_attributes!(contribution: contribution + amount)
    fund if contribution >= goal
  end

  def next_unachieved_milestone
    milestones.each do |milestone|
      return milestone unless milestone.achieved?
    end
    nil
  end

  aasm_column :aasm_state

  # State machine that goes through the diferent states
  aasm do
    state :pending, initial: true
    state :approved
    state :rejected
    state :started_not_funded
    state :closed_funded
    state :closed_partially_funded
    state :closed_not_funded

    event :approve do
      transitions from: :pending, to: :approved
      transitions from: :pending, to: :fund
      transitions from: :rejected, to: :approved
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :fund do
      transitions from: :pending, to: :closed_funded, guard: :funded?
      transitions from: :closed_funded, to: :closed_funded, guard: :funded?
      transitions from: :started_not_funded, to: :closed_funded, guard: :funded?
    end

    event :start do
      transitions from: :approved, to: :started_not_funded
    end

    event :close do
      transitions from: :started_not_funded,
                  to: :closed_funded,
                  guard: :funded?
      transitions from: :started_not_funded,
                  to: :closed_partially_funded,
                  guard: :partially_funded?
      transitions from: :started_not_funded,
                  to: :closed_not_funded
    end

  end

  private

  def funded?
    goal <= contribution
  end

  def partially_funded?
    milestones.first.amount <= contribution
  end

  def default_attributes
    self.contribution ||= 0.0
  end

end
