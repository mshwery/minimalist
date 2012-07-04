class ChangeNametoDescription < ActiveRecord::Migration
  def change
    rename_column :tasks, :name, :description
  end
end
