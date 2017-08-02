class GameController < ApplicationController
  def board
    byebug
    current_game = GameRecord.order(created_at: :desc).first
    players = User.where(game_record: current_game)
    @player_one = players.where(color: :blue).name
    @player_two = players.where(color: :red).name
  end

  def index
  end
end
