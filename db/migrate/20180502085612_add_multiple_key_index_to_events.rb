class AddMultipleKeyIndexToEvents < ActiveRecord::Migration[5.1]
  def change
    add_index :events, [:user_id, :movie_id], unique: true
  end
end
