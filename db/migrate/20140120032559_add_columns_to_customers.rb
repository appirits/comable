require 'comable/table_definition'

class AddColumnsToCustomers < ActiveRecord::Migration
  def change
    Comable::TableDefinition.new(self).change_table do |t|
      t.string :family_name, null: false
      t.string :first_name, null: false
    end
  end
end
