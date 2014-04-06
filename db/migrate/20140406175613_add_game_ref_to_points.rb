class AddGameRefToPoints < ActiveRecord::Migration
  def change
    add_reference :points, :game, index: true
  end
end
