class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_owner

  def id
    List.hashids.encode(object.id)
  end

  def is_owner
    object.owned_by?(scope.current_user)
  end
end
