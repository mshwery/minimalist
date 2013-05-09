class List < ActiveRecord::Base

  validates :name,  :presence => true
  has_many :tasks, :dependent => :delete_all
  belongs_to :stack
  
  accepts_nested_attributes_for :tasks, :allow_destroy => true
  attr_accessible :name, :slug # should we be including slug?

  validates_format_of :slug, :with => /\A[a-z\-0-9]*\Z/
  before_validation :generate_name, :on => :create 
  before_save :generate_slug
  after_create :update_count

  def to_param
    slug
  end

  def update_count
    Stat.increment_count_of(:lists_count)
  end

  private

  def generate_name
    if self.name.blank?
      self.name = 'untitled'
    end
  end

  def generate_slug
    slug = self.name.mb_chars.downcase.normalize(:kd).to_s.gsub(/-/, " ").squeeze(" ")
    slug = slug.gsub(/\s/, "-").gsub(/[^a-z\-0-9]/, "")

    current = 1
    self.slug = slug
    while true
      conflicts = List.where("slug = ?", self.slug).count
      if conflicts != 0 || self.slug == 'new'
        self.slug = "#{slug}-#{current}"
        current += 1
      else
        break
      end
    end
  end

end
