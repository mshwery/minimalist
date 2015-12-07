class CreateJoinTableUserList < ActiveRecord::Migration
  def change
    create_join_table :users, :lists do |t|
      t.index [:user_id, :list_id]
      t.index [:list_id, :user_id]
    end
  end
end
