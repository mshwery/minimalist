class Task < ActiveRecord::Base
  
  belongs_to :list, touch: true
  validates :description, presence: true

  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :remaining, -> { where completed: false }

  after_create :update_count

  def to_json(options = {})
    super(options.merge(:only => [ :id, :list_id, :description, :completed, :sort_order ]))
  end

  def update_count
    Stat.increment_count_of(:tasks_count)
  end

end
