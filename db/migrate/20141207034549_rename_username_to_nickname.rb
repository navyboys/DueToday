class RenameUsernameToNickname < ActiveRecord::Migration
  def change
    rename_column :users, :user_name, :nick_name
  end
end
