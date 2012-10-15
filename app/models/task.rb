class Task < ActiveRecord::Base
  
  belongs_to :list
  validates :description, :presence => true
  attr_accessible :description, :completed, :sort_order

  scope :existing, where(:deleted_at => nil)
  scope :deleted, where('tasks.deleted_at IS NOT NULL')

  def to_json(options = {})
    super(options.merge(:only => [ :id, :list_id, :description, :completed, :sort_order ]))
  end

  def delete!
    self.deleted_at = Time.now
    self.save!    
  end

end
