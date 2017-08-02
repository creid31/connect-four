class User < ApplicationRecord
  belongs_to :game_record
  enum color: [:blue, :red]
end
