class AddIndexToSummaries < ActiveRecord::Migration
  def change
    add_index :summaries, :user_id
  end
end
