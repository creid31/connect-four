class User < ApplicationRecord
  belongs_to :game_record
  enum color: %i[blue red]

  def self.create_users(name_one, name_two, ai_flag, game_id)
    create(name: name_one, color: :blue, game_record_id: game_id)
    create(name: name_two, color: :red, game_record_id: game_id, ai: ai_flag)
  end

  def move(column)
    slot = BoardSlot.next_slot(column, game_record)
    slot.update(user: self, final: true)
    slot
  end

  def ai_move(opponent)
    max_col = game_record.num_cols - 1
    # ai column -> score
    possible_moves = {}
    ai_slot = nil
    opp_slot = nil
    (0..max_col).each do |ai_x|
      ai_slot = BoardSlot.next_slot(ai_x, game_record)
      ai_slot.update(user: self, final: false)
      score = 0
      (0..max_col).each do |opp_x|
        opp_slot = BoardSlot.next_slot(opp_x, game_record)
        opp_slot.update(user: opponent, final: false)
        score += game_record.score_board
        BoardSlot.where(final: false).update_all(user_id: nil)
      end
      possible_moves[ai_x] = score

    end
    byebug
    # maximum score of all moves is the one the AI should taken
    max_score = possible_moves.values.max
    ai_col = possible_moves.key(max_score)
    move(ai_col)
  end
end
