require 'matrix'
class GameRecord < ApplicationRecord
  has_many :users
  has_many :board_slots

  validates :num_cols, presence: true,
                       numericality: { only_integer: true,
                                       greater_than_or_equal_to: 7 }
  validates :num_rows, presence: true,
                       numericality: { only_integer: true,
                                       greater_than_or_equal_to: 6 }
  scope :current_game, -> { order(created_at: :desc).first }

  def generate_board_slots(num_rows, num_cols)
    Matrix.build(num_rows, num_cols) { |y, x|
      BoardSlot.create(game_record: self, x_coordinate: x, y_coordinate: y)
               .appearance
    }.to_a
  end

  def retrieve_slots
    board = Matrix.build(num_rows, num_cols) { nil }.to_a
    board_slots.each do |slot|
      board[slot.y_coordinate][slot.x_coordinate] = slot.appearance
    end
    board.to_a
  end

  def next_player
    current_player = users.where(currently_playing: true).first
    next_player = users.where(currently_playing: false).first
    current_player.update(currently_playing: false)
    next_player.update(currently_playing: true)
    return current_player, next_player
  end


    def check_for_win(curr_slot)
      x = curr_slot.x_coordinate
      y = curr_slot.y_coordinate

      rows = (0..num_rows - 1).to_a.reverse
      cols = (0..num_cols - 1).to_a

      user = nil
      # horizontal
      horizontal_count = 0
      cols.each do |col|
        slot = board_slots.where(y_coordinate: y, x_coordinate: col).first
        # next if slot.eql?(curr_slot)
        break if slot.user.nil?
        horizontal_count = 0 if user != slot.user
        horizontal_count += 1
        user = slot.user
      end
      return user if horizontal_count >= 4

      # vertical
      vertical_count = 0
      rows.each do |row|
        slot = board_slots.where(y_coordinate: row, x_coordinate: x).first
        # next if slot.eql?(curr_slot)
        break if slot.user.nil?
        vertical_count = 0 if user != slot.user
        vertical_count += 1
        user = slot.user
      end
      return user if vertical_count >= 4

      # diagonal left
      # diagonal right
    end
end
