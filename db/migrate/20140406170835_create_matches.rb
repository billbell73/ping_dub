class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :winner, index: true
      t.references :p1, index: true
      t.references :p2, index: true
      t.boolean :doubles_match

      t.timestamps
    end
  end
end
