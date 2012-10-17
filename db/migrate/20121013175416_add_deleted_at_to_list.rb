class AddDeletedAtToList < ActiveRecord::Migration
  def change
    add_column :lists, :deleted_at, :datetime
  end
end
