class BoardSlot < ApplicationRecord
  belongs_to :game_record
  belongs_to :user, optional: true

  def appearance
    if user.nil?
      '-'
    else
      user.color
    end
  end
end
