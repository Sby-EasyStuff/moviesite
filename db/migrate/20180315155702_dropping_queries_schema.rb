class DroppingQueriesSchema < ActiveRecord::Migration[5.1]
  def change
    drop_table :queries
  end
end
