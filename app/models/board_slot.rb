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

  def self.next_slot(col, current_game, num_rows)
    rows = (0..num_rows - 1).to_a.reverse
    rows.each do |row|
      slot = BoardSlot.where(x_coordinate: col,
                             y_coordinate: row,
                             game_record_id: current_game).first
      return slot unless slot.taken
    end
  end
end
