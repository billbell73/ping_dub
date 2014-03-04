class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.boolean :p1_on_left

      t.timestamps
    end
  end
end
