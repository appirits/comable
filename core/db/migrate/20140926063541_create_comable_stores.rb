class CreateComableStores < ActiveRecord::Migration
  def change
    create_table :comable_stores do |t|
      t.string :name
      t.string :meta_keywords
      t.string :meta_description
      t.string :email_sender
      t.timestamps null: false
    end
  end
end
