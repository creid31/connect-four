class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :points, default: 0
      t.integer :color
      t.references :game_record, foreign_key: true

      t.timestamps
    end
  end
end
