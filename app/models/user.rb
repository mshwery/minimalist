class User < ActiveRecord::Base

  has_many :memberships
  has_many :lists, :through => :memberships

  def self.from_omniauth(auth)
    find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.nickname = auth["info"]["nickname"]
      user.name = auth["info"]["name"]
    end
  end

  def display_name
    at_nickname || name
  end

  def at_nickname
    "@#{nickname}" if nickname
  end
  
end
