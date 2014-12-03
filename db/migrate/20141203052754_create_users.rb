class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :option => 'CHARSET=UTF8' do |t|
      t.string :email
      t.string :password_digest
      t.string :user_name
      t.timestamps
    end
  end
end
