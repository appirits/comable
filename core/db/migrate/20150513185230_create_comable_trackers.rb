class CreateComableTrackers < ActiveRecord::Migration
  def change
    create_table :comable_trackers do |t|
      # TODO: Rename the column: activate_flag => activated
      t.boolean :activate_flag, null: false, default: true
      t.string :name, null: false
      t.string :tracker_id
      t.text :code, null: false
      t.string :place, null: false
      t.timestamps null: false
    end
  end
end
