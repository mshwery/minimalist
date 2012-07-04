class AddIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :list_id, :integer
  end
end
