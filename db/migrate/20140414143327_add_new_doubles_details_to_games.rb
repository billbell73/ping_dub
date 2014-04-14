class AddNewDoublesDetailsToGames < ActiveRecord::Migration
  def change
    add_column :games, :p1_started_game_serving, :boolean
    add_column :games, :p1_partners_in_id_order, :boolean
    add_column :games, :p2_partners_in_id_order, :boolean
  end
end
