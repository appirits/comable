Comable::Sample.import('orders')
Comable::Sample.import('shipment_methods')

shipment_method = Comable::ShipmentMethod.first

Comable::Order.complete.each do |order|
  shipment = order.shipments.create!(shipment_method: shipment_method, fee: shipment_method.fee)
  shipment.state = 'ready'
  shipment.save!
end
