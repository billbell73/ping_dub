class AddReceiverSwitchedToGames < ActiveRecord::Migration
  def change
    add_column :games, :receiver_order_switched, :boolean
  end
end
