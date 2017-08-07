class AddFinalBoolToBoardSlot < ActiveRecord::Migration[5.1]
  def change
    add_column :board_slots, :final, :boolean
  end
end
