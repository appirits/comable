Comable::Sample.import('products')
Comable::Sample.import('stocks')
Comable::Sample.import('addresses')

bill_address = Comable::Address.first
ship_address = Comable::Address.second
suede_dress = Comable::Product.find_by!(name: Comable::Sample.t(:suede_dress))
girly_coat = Comable::Product.find_by!(name: Comable::Sample.t(:girly_coat))

orders_attributes = [
  {
    email: 'comable@example.com',
    bill_address: bill_address,
    ship_address: ship_address,
    shipment_fee: 300,
    payment_fee: 200,
    total_price: 500 + suede_dress.price,
    order_items_attributes: [
      {
        stock: suede_dress.stocks.first,
        quantity: 1
      }
    ]
  },
  {
    email: 'comable@example.com',
    bill_address: bill_address,
    ship_address: ship_address,
    shipment_fee: 300,
    payment_fee: 200,
    total_price: 500 + (suede_dress.price * 2) + (girly_coat.price * 3),
    order_items_attributes: [
      {
        stock: suede_dress.stocks.first,
        quantity: 2
      },
      {
        stock: girly_coat.stocks.first,
        quantity: 3
      }
    ]
  }
]

orders_attributes.each do |attributes|
  order = Comable::Order.create!(attributes)
  order.send(:generate_code)
  order.state = 'completed'
  order.completed_at = Time.now
  order.save!
end
