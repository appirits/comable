class AddPublishedAtToComableProducts < ActiveRecord::Migration
  def change
    change_table :comable_products do |t|
      t.datetime :published_at
    end

    Comable::Product.update_all(published_at: (Rails::VERSION::MAJOR == 3) ? Date.today.to_time_in_current_zone : Date.today.in_time_zone) unless reverting?
  end
end
