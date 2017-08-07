class BoardSlot < ApplicationRecord
  belongs_to :game_record
  belongs_to :user, optional: true

  def appearance
    if user.nil?
      '-'
    else
      user.color
    end
  end

  def taken
    !user.nil?
  end

  def self.pretty_print_slots(current_game)
    board = Matrix.build(current_game.num_rows, current_game.num_cols) { nil }.to_a
    where(game_record: current_game).each do |slot|
      board[slot.y_coordinate][slot.x_coordinate] = slot.appearance
    end
    board.to_a
  end

  def self.next_slot(col, current_game)
    rows = (0..current_game.num_rows - 1).to_a.reverse
    rows.each do |row|
      slot = BoardSlot.where(x_coordinate: col,
                             y_coordinate: row,
                             game_record: current_game).first
      return slot unless slot.taken
    end
  end
end
