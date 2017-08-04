require 'matrix'
class GameRecord < ApplicationRecord
  has_many :user
  has_many :board_slots

  attr_accessor :current_players

  def generate_board_slots(num_rows, num_cols)
    Matrix.build(num_rows, num_cols) { |x, y|
      BoardSlot.create(game_record: self, x_coordinate: x, y_coordinate: y)
               .appearance
    }.to_a
  end

  def retrieve_slots
    board = Matrix.build(6, 7) { nil }.to_a
    slots = board_slots
    slots.each do |slot|
      board[slot.x_coordinate][slot.y_coordinate] = slot.appearance
    end
    board.to_a
  end

  def next_player
    current_player = current_players.where(currently_playing: true).first
    next_player = current_players.where(currently_playing: false).first
    current_player.currently_playing = false
    next_player.currently_playing = true
    return current_player, next_player
  end
end
