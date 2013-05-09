class Task < ActiveRecord::Base
  
  belongs_to :list
  validates :description, :presence => true
  attr_accessible :description, :completed, :sort_order

  scope :deleted, where('tasks.deleted_at IS NOT NULL')
  scope :remaining, where(:completed => false)

  after_create :update_count

  def to_json(options = {})
    super(options.merge(:only => [ :id, :list_id, :description, :completed, :sort_order ]))
  end

  def update_count
    Stat.increment_count_of(:tasks_count)
  end

end
