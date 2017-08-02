class UsersController < ApplicationController
  def index
    render plain: params.inspect
  end

  def create
    puts params.as_json
    current_game = GameRecord.create
    User.create(name: params[:player_one],
                color: :blue,
                game_record: current_game)
    User.create(name: params[:player_two],
                color: :red,
                game_record: current_game)
    redirect_to game_board_path
  end
end
