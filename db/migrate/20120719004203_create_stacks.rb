class CreateStacks < ActiveRecord::Migration
  def change
    create_table :stacks do |t|
      t.string :token

      t.timestamps
    end
  end
end
