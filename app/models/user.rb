class User < ApplicationRecord
  belongs_to :game_record
  validates :name, uniqueness: true
  enum color: [:blue, :red]
end
