class DropUrlFromMovies < ActiveRecord::Migration[5.1]
  def change
    remove_column :movies, :url   
  end
end
