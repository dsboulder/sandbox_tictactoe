class AddForfeitToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :forfeit, :string
  end

  def self.down
    remove_column :boards, :forfeit
  end
end
