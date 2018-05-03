class CreateTrailers < ActiveRecord::Migration[5.1]
  def change
    create_table :trailers do |t|
      t.string :api_id
      t.references :movie, foreign_key: true
      t.string :thumbnail

      t.timestamps
    end
  end
end
