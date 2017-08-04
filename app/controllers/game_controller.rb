class GameController < ApplicationController
  class << self
    attr_accessor :current_game
    attr_accessor :num_rows
    attr_accessor :num_cols
  end

  def start_board
    @current_game = GameController.current_game = GameRecord.order(created_at: :desc).first
    @current_game.current_players = players = User.where(game_record: @current_game)

    @player_one = players.where(color: :blue).first
    @player_one.update(currently_playing: true)
    @current_player = @player_one.name

    @row = GameController.num_rows = 6
    @col = GameController.num_cols = 7
    @slots = @current_game.generate_board_slots(@row, @col)
  end

  def make_move
    @row = GameController.num_rows
    @col = GameController.num_cols
    @current_game = GameController.current_game

    previous_player, next_player = @current_game.next_player
    row_id = params[:row_id]
    col_id = params[:col_id]
    next_slot = BoardSlot.where(x_coordinate: col_id,
                                y_coordinate: row_id,
                                game_record: @current_game).first

    if !next_slot.user.nil?
      @current_player = previous_player.name
      flash[:alert] = 'Spot already taken please try again'
    else
      previous_player.save!
      next_player.save!

      next_slot.update(user: previous_player)

      @current_player = next_player.name
    end
    @slots = @current_game.retrieve_slots
  end
end
