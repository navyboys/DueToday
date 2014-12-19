class RenameNameToTitleForTodos < ActiveRecord::Migration
  def change
    rename_column :todos, :name, :title
  end
end
