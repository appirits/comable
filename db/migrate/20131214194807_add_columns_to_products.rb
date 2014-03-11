require 'comable/table_definition'

class AddColumnsToProducts < ActiveRecord::Migration
  def change
    Comable::TableDefinition.new(self).change_table do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.integer :price
      t.text :caption
    end
  end
end
