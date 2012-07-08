class List < ActiveRecord::Base

  validates :name,  :presence => true
  has_many :tasks
  
  accepts_nested_attributes_for :tasks
end
