class Membership < ActiveRecord::Base

  belongs_to :list
  belongs_to :user

  validates :user_id, :uniqueness => { :scope => :list_id, :message => "is already a member." }

  attr_accessible

end
