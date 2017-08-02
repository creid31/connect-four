class CreateGameRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :game_records do |t|
      t.timestamps
    end
  end
end
