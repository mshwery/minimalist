class RemoveDescriptionFromLists < ActiveRecord::Migration
  def up
    remove_column :lists, :description
  end

  def down
    add_column :lists, :description, :text
  end
end
