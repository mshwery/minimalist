class AddSortOrderToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :sort_order, :integer

  end
end
