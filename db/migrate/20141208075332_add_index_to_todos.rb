class AddIndexToTodos < ActiveRecord::Migration
  def change
    add_index :todos, :user_id
  end
end
