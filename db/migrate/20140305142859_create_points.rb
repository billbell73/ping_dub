class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :winner_id
      t.integer :server_id
      t.boolean :p1_on_left
    end
  end
end
