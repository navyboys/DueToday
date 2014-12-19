class RenameNicknameToNameForUsers < ActiveRecord::Migration
  def change
    rename_column :users, :nick_name, :name
  end
end
