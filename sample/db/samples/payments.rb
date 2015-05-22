Comable::Sample.import('orders')
Comable::Sample.import('payment_methods')

payment_method = Comable::PaymentMethod.first

Comable::Order.complete.each do |order|
  payment = order.create_payment!(payment_method: payment_method, fee: payment_method.fee)
  payment.state = 'completed'
  payment.completed_at = Time.now
  payment.save!
end
