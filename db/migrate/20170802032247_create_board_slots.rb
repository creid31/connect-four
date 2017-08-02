class CreateBoardSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :board_slots do |t|
      t.integer :x_coordinate
      t.integer :y_coordinate
      t.references :user, foreign_key: true
      t.references :game_record, foreign_key: true

      t.timestamps
    end
  end
end
