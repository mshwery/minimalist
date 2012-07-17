class AddSlugToList < ActiveRecord::Migration
  def change
    add_column :lists, :slug, :string

  end
end
