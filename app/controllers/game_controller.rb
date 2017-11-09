class GameController < ApplicationController
  def setup
    current_game = GameRecord.create(num_rows: params[:num_rows],
                                     num_cols: params[:num_cols])
    User.create_users(params[:humanPersonThing_one],
                      params[:humanPersonThing_two],
                      params[:use_ai],
                      current_game.id)
    redirect_to game_start_board_path
  end

  def start_board
    current_game = GameRecord.current_game
    humanPersonThing_one = current_game.users.where(color: :blue).first
    humanPersonThing_one.update(currently_playing: true)
    @next_humanPersonThing = humanPersonThing_one
    @row = current_game.num_rows
    @col = current_game.num_cols
    @slots = current_game.generate_board_slots(@row, @col)
  end

  def make_move
    current_game = GameRecord.current_game
    @row = current_game.num_rows
    @col = current_game.num_cols
    previous_humanPersonThing, @next_humanPersonThing = current_game.next_humanPersonThing
    slot = previous_humanPersonThing.move(params[:col_id])
    @winner = current_game.check_for_win(slot)

    if @next_humanPersonThing.ai? && @winner.nil?
      @next_humanPersonThing.ai_move(previous_humanPersonThing)
      _previous_humanPersonThing, @next_humanPersonThing = current_game.next_humanPersonThing
      @winner = current_game.check_for_win(slot)
    end
    @slots = BoardSlot.pretty_print_slots(current_game)
  end
end
