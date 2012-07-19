class AddStackIdToLists < ActiveRecord::Migration
  def change
    add_column :lists, :stack_id, :integer

  end
end
