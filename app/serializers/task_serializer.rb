class TaskSerializer < ActiveModel::Serializer
  attributes :id, :description, :completed, :created_at, :updated_at, :sort_order
end
