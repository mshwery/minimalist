class Stack < ActiveRecord::Base

  has_many :lists
  
  accepts_nested_attributes_for :lists, :allow_destroy => true

  validates_presence_of :token
  validates_uniqueness_of :token

  before_validation :generate_token, :on => :create 
  
  def to_param
    token
  end

  protected

    def generate_token
      self.token = rand(36**10).to_s(36) if self.new_record? and self.token.nil?
    end
end
