class AddRowsColsToGameRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :game_records, :num_rows, :integer
    add_column :game_records, :num_cols, :integer
  end
end
