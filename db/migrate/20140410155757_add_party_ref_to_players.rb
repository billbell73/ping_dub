class AddPartyRefToPlayers < ActiveRecord::Migration
  def change
    add_reference :players, :party, index: true
  end
end
