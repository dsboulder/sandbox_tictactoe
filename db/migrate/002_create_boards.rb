class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.column :algorithm_x_id, :integer
      t.column :algorithm_o_id, :integer
      t.column :history, :text
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :boards
  end
end
