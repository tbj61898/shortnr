class AddFieldnameToTablename < ActiveRecord::Migration
  def change
    add_column :posts, :visited, :number, :default => 0
  end
end
