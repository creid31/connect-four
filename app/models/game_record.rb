require 'matrix'
class GameRecord < ApplicationRecord
  has_many :users
  has_many :board_slots

  validates :num_cols, presence: true,
                       numericality: { only_integer: true,
                                       greater_than_or_equal_to: 7,
                                       odd: true }
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

  def next_humanPersonThing
    current_humanPersonThing = users.where(currently_playing: true).first
    next_humanPersonThing = users.where(currently_playing: false).first
    current_humanPersonThing.update(currently_playing: false)
    next_humanPersonThing.update(currently_playing: true)
    return current_humanPersonThing, next_humanPersonThing
  end

  def check_for_win(curr_slot)
    x = curr_slot.x_coordinate
    y = curr_slot.y_coordinate

    user = check_horizontal(y)
    return user unless user.nil?

    user = check_vertical(x)
    return user unless user.nil?

    board = BoardSlot.pretty_print_slots(self)
    user = check_diag_down(board)
    return user unless user.nil?

    user = check_diag_up(board)
    return user unless user.nil?
  end

  def check_horizontal(y)
    user = nil
    horizontal_count = 0
    (0..num_cols - 1).to_a.each do |col|
      slot = board_slots.where(y_coordinate: y, x_coordinate: col).first
      break if slot.user.nil?
      horizontal_count = 0 if user != slot.user
      horizontal_count += 1
      user = slot.user
    end
    return user if horizontal_count >= 4
  end

  def check_vertical(x)
    user = nil
    vertical_count = 0
    (0..num_rows - 1).to_a.reverse.each do |row|
      slot = board_slots.where(y_coordinate: row, x_coordinate: x).first
      break if slot.user.nil?
      vertical_count = 0 if user != slot.user
      vertical_count += 1
      user = slot.user
    end
    return user if vertical_count >= 4
  end

  def check_diag_down(board)
    user = nil
    (0..num_cols - 4).each do |x|
      (0..num_rows - 4).each do |y|
        user = check_win_in_set([board[y][x],
                                 board[y + 1][x + 1],
                                 board[y + 2][x + 2],
                                 board[y + 3][x + 3]])
        return user unless user.nil?
      end
    end
    user
  end

  def check_diag_up(board)
    user = nil
    (0..num_cols - 4).each do |x|
      (3..num_rows - 1).each do |y|
        user = check_win_in_set([board[y][x],
                                 board[y - 1][x + 1],
                                 board[y - 2][x + 2],
                                 board[y - 3][x + 3]])
        return user unless user.nil?
      end
    end
    user
  end


  def score_board
    score = 0
    board = BoardSlot.pretty_print_slots(self)
    score += horizontal_score(board)
    score += vertical_score(board)
    score += diag_up_right_score(board)
    score += diag_down_left_score(board)
    score
  end

  # For each row, evaluate potential four spot combos
  def horizontal_score(board)
    score = 0
    (0..num_rows - 1).each do |y|
      (0..num_cols - 4).each do |x|
        score += score_set_of_four([board[y][x],
                                    board[y][x + 1],
                                    board[y][x + 2],
                                    board[y][x + 3]])
      end
    end
    score
  end

  def vertical_score(board)
    score = 0
    (0..num_cols - 1).each do |x|
      (0..num_rows - 4).each do |y|
        score += score_set_of_four([board[y][x],
                                    board[y + 1][x],
                                    board[y + 2][x],
                                    board[y + 3][x]])
      end
    end
    score
  end

  def diag_down_score(board)
    score = 0
    (0..num_cols - 4).each do |x|
      (0..num_rows - 4).each do |y|
        score += score_set_of_four([board[y][x],
                                    board[y + 1][x + 1],
                                    board[y + 2][x + 2],
                                    board[y + 3][x + 3]])
      end
    end
    score
  end

  def diag_up_score(board)
    score = 0
    (0..num_cols - 4).each do |x|
      (3..num_rows - 1).each do |y|
        score += score_set_of_four([board[y][x],
                                    board[y - 1][x + 1],
                                    board[y - 2][x + 2],
                                    board[y - 3][x + 3]])
      end
    end
    score
  end

  # Evaluate score of four potential spots
  def score_set_of_four(set_of_four)
    # opponent
    blue = 0
    # ai
    red = 0
    set_of_four.each do |slot|
      blue += 1 if slot == 'blue'
      red += 1 if slot == 'red'
    end
    score = 0
    if blue > 0 && red > 0
    elsif blue > 0
      score = -(10**(blue - 1))
    elsif red > 0
      score = 10**(red - 1)
    end
    score
  end

  def check_win_in_set(set_of_four)
    # opponent
    blue = 0
    # ai
    red = 0
    set_of_four.each do |slot|
      blue += 1 if slot == 'blue'
      red += 1 if slot == 'red'
    end
    byebug if blue >= 4 || red >= 4
    return users.blue.first if blue == 4
    return users.red.first if red == 4
  end
end
