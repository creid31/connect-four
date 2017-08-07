class GameController < ApplicationController
  def setup
    current_game = GameRecord.create(num_rows: params[:num_rows],
                                     num_cols: params[:num_cols])
    User.create_users(params[:player_one],
                      params[:player_two],
                      params[:use_ai],
                      current_game.id)
    redirect_to game_start_board_path
  end

  def start_board
    current_game = GameRecord.current_game
    player_one = current_game.users.where(color: :blue).first
    player_one.update(currently_playing: true)
    @next_player = player_one
    @row = current_game.num_rows
    @col = current_game.num_cols
    @slots = current_game.generate_board_slots(@row, @col)
  end

  def make_move
    current_game = GameRecord.current_game
    @row = current_game.num_rows
    @col = current_game.num_cols
    previous_player, @next_player = current_game.next_player
    slot = previous_player.move(params[:col_id])
    @winner = current_game.check_for_win(slot)

    if @next_player.ai? && @winner.nil?
      @next_player.ai_move(previous_player)
      _previous_player, @next_player = current_game.next_player
      @winner = current_game.check_for_win(slot)
    end

    @slots = current_game.retrieve_slots
  end
end
