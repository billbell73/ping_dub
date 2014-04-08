class AddChoicesToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :best_of, :integer
    add_column :matches, :p1_starts_left, :boolean
    add_column :matches, :p1_first_server, :boolean
  end
end
