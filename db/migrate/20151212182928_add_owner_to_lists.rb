class AddOwnerToLists < ActiveRecord::Migration
  def change
    add_reference :lists, :owner, references: :users
    add_foreign_key :lists, :users, column: :owner_id
  end
end
