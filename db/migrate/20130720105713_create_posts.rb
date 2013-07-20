class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :longurl
      t.text :description
      t.string :shorturl

      t.timestamps
    end
  end
end
