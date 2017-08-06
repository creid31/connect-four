class GameController < ApplicationController
  def setup
    puts params.as_json
    current_game = GameRecord.create(num_rows: params[:num_rows],
                                     num_cols: params[:num_cols])
    User.create(name: params[:player_one],
                color: :blue,
                game_record: current_game)
    User.create(name: params[:player_two],
                color: :red,
                game_record: current_game)
    redirect_to game_start_board_path
  end

  def start_board
    @current_game = GameRecord.current_game
    @player_one = @current_game.users.where(color: :blue).first
    @player_one.update(currently_playing: true)
    @current_player = @player_one
    @row = @current_game.num_rows
    @col = @current_game.num_cols
    @slots = @current_game.generate_board_slots(@row, @col)
  end

  def make_move
    @current_game = GameRecord.current_game
    @row = @current_game.num_rows
    @col = @current_game.num_cols
    previous_player, @current_player = @current_game.next_player
    slot = BoardSlot.next_slot(params[:col_id], @current_game.id, @row)
    slot.update(user: previous_player)
    @winner = @current_game.check_for_win(slot)
    @slots = @current_game.retrieve_slots
  end
end
