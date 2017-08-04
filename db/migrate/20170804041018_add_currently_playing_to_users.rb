class AddCurrentlyPlayingToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :currently_playing, :boolean, default: false
  end
end
