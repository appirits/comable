class SetDefaultStockLocation < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { set_default_stock_location }
    end
  end

  private

  def set_default_stock_location
    set_default_stock_location_on(Comable::Shipment)
    set_default_stock_location_on(Comable::Stock)
  end

  def set_default_stock_location_on(model)
    records = model.where(stock_location_id: nil)
    return unless records.exists?
    stock_location = find_or_create_default_stock_location
    records.update_all(stock_location_id: stock_location.id)
  end

  def find_or_create_default_stock_location
    Comable::StockLocation.where(default: true).first_or_initialize do |stock_location|
      stock_location.name = Comable.t(:default)
      stock_location.save!
    end
  end
end
