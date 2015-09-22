class ListSerializer < ActiveModel::Serializer
  attributes :id, :name

  def id
    List.hashids.encode(object.id)
  end
end
