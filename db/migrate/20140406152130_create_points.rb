class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.references :winner, index: true
      t.references :server, index: true
      t.boolean :p1_on_left
    end
  end
end
