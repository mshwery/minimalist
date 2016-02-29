class UserSerializer < ActiveModel::Serializer
  attributes :name, :email, :image_url, :is_owner

  def is_owner
    list = options[:list]
    object.owns_list?(list)
  end

  def include_email?
    list = options[:list]
    list.owned_by?(scope.current_user)
  end
end
