class GameController < ApplicationController
  @current_game = nil
  def board
    @current_game = GameRecord.order(created_at: :desc).first
    players = User.where(game_record: @current_game)
    @player_one = players.where(color: :blue).first
    @player_two = players.where(color: :red).first
    @slots = generate_board(6, 7)
  end

  def index
  end

  def generate_board(row_size, col_size)
    board = []
    (0..row_size - 1).each do |x|
      row = []
      (0..col_size - 1).each do |y|
        slot = BoardSlot.create(game_record: @current_game, x_coordinate: x, y_coordinate: y)
        row << slot
      end
      board << row
    end
    board
  end
end
