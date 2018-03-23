class AddUrlToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :url, :string
  end
end
