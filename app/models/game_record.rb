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

  def next_player
    current_player = users.where(currently_playing: true).first
    next_player = users.where(currently_playing: false).first
    current_player.update(currently_playing: false)
    next_player.update(currently_playing: true)
    return current_player, next_player
  end

  def check_for_win(curr_slot)
    x = curr_slot.x_coordinate
    y = curr_slot.y_coordinate

    rows = (0..num_rows - 1).to_a.reverse
    cols = (0..num_cols - 1).to_a

    user = check_horizontal(cols, y)
    return user unless user.nil?

    user = check_vertical(rows, x)
    return user unless user.nil?
    # diagonal left
    # diagonal right
  end

  def check_horizontal(columns, y)
    user = nil
    # horizontal
    horizontal_count = 0
    columns.each do |col|
      slot = board_slots.where(y_coordinate: y, x_coordinate: col).first
      break if slot.user.nil?
      horizontal_count = 0 if user != slot.user
      horizontal_count += 1
      user = slot.user
    end
    return user if horizontal_count >= 4
  end

  def check_vertical(rows, x)
    user = nil
    vertical_count = 0
    rows.each do |row|
      slot = board_slots.where(y_coordinate: row, x_coordinate: x).first
      break if slot.user.nil?
      vertical_count = 0 if user != slot.user
      vertical_count += 1
      user = slot.user
    end
    return user if vertical_count >= 4
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

  def diag_up_right_score(board)
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

  def diag_down_left_score(board)
    score = 0
    (0..num_cols - 4).each do |x|
      (3..num_rows - 1).each do |y|
        # puts("x: #{x} & y: #{y}")
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
    if blue > 0
      score = (-10)**blue
    elsif red > 0
      score = 10**red
    end
    score
  end
end
