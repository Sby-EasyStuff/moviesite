class RemovingMoviesFromQuery < ActiveRecord::Migration[5.1]
  def change
    remove_column :queries, :movies
  end
end
