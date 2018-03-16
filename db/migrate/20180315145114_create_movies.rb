class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.integer :api_id
      t.string :title
      t.float :vote_average
      t.date :release_date
      t.text :overview
      t.string :url
      t.string :poster_path

      t.timestamps
    end
  end
end
