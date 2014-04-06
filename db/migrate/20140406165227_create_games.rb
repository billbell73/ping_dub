class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :winner, index: true

      t.timestamps
    end
  end
end
