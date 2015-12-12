class AddUniqueIndexOnListsUsers < ActiveRecord::Migration
  def change
    remove_index :lists_users, [:list_id, :user_id]
    add_index :lists_users, [:list_id, :user_id], unique: true
  end
end
