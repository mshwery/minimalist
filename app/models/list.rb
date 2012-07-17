class List < ActiveRecord::Base

  validates :name,  :presence => true
  has_many :tasks
  
  accepts_nested_attributes_for :tasks, :allow_destroy => true

  validates_presence_of :slug
  validates_uniqueness_of :slug

  before_validation :generate_slug, :on => :create    
  
  def to_param
    slug
  end

  protected

    def generate_slug
      self.slug = rand(36**8).to_s(36) if self.new_record? and self.slug.nil?
    end

end
