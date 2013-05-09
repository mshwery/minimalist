class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :tasks_count
      t.integer :lists_count

      t.timestamps
    end
  end
end
