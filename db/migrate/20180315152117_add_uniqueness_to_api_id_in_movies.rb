class AddUniquenessToApiIdInMovies < ActiveRecord::Migration[5.1]
  def change
    add_index :movies, :api_id, unique: true
  end
end
