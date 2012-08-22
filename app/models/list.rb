class List < ActiveRecord::Base

  validates :name,  :presence => true
  has_many :tasks
  belongs_to :stack
  
  accepts_nested_attributes_for :tasks, :allow_destroy => true
  accepts_nested_attributes_for :stack
  attr_accessible :name, :slug

  validates_format_of :slug, :with => /\A[a-z\-0-9]*\Z/
  before_validation :generate_name, :on => :create 
  before_save :generate_slug
  #before_validation :generate_slug, :on => :create   

  def to_param
    slug
  end

  def remaining
    return self.tasks.where(:completed => false)
  end

  private

  def generate_name
    if self.name.blank?
      self.name = 'untitled'
    end
  end

  def generate_slug
    #if self.slug.blank?
      slug = self.name.mb_chars.downcase.normalize(:kd).to_s.gsub(/-/, " ").squeeze(" ")
      slug = slug.gsub(/\s/, "-").gsub(/[^a-z\-0-9]/, "")

      current = 1
      self.slug = slug
      while true
        conflicts = List.where("slug = ?", self.slug).count
        if conflicts != 0
          self.slug = "#{slug}-#{current}"
          current += 1
        else
          break
        end
      end
    #end
  end

end
