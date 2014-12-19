class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.integer :user_id
      t.date :date
      t.text :description
      t.timestamps
    end
  end
end
