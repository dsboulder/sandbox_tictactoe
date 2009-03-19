class CreateMoves < ActiveRecord::Migration
  def self.up
    create_table :moves do |t|
      t.column :board_id, :integer
      t.column :x_pos, :integer
      t.column :y_pos, :integer
      t.column :is_x, :boolean
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :moves
  end
end
