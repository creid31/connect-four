class AddAiBooleanToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :ai, :boolean
  end
end
