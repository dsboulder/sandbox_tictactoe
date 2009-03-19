class CreateAlgorithms < ActiveRecord::Migration
  def self.up
    create_table :algorithms do |t|
      t.column :name, :string
      t.column :author, :string
      t.column :code, :text
      t.column :password, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :algorithms
  end
end
