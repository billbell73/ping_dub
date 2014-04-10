class AddDoublesDetailsToGames < ActiveRecord::Migration
  def change
    add_column :games, :p1_started_game_serving, :boolean
    add_column :games, :initial_server_first_partner, :boolean
    add_column :games, :initial_receiver_first_partner, :boolean
  end
end
