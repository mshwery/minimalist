class List < ActiveRecord::Base

  validates :name,  :presence => true
  belongs_to :stack
  has_many :tasks
  has_many :memberships
  has_many :users, :through => :memberships
  
  accepts_nested_attributes_for :tasks
  attr_accessible :name, :slug # should we be including slug?

  default_scope where(deleted_at: nil)

  validates_format_of :slug, :with => /\A[a-z\-0-9]*\Z/
  before_validation :generate_name, :on => :create 
  before_save :generate_slug

  def to_param
    slug
  end

  def delete!
    self.deleted_at = Time.now
    self.save!
  end

  def build_membership_for(u)
    membership = self.memberships.new
    membership.user = u
    self.save
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
