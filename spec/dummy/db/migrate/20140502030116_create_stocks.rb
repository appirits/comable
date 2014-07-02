class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :units, nil: false
      t.timestamps
    end
  end
end
