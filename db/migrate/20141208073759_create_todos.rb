class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :user_id
      t.string :name
      t.string :status
      t.date :due
      t.timestamps
    end
  end
end
