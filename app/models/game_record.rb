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
    current_player.currently_playing = false
    next_player.currently_playing = true
    return current_player, next_player
  end
end
